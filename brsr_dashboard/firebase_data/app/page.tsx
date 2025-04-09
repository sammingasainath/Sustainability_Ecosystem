'use client';

import React, { useEffect, useState } from 'react';
import { Box, Grid, useColorMode, Flex } from '@chakra-ui/react';
import { collection, getDocs, query, where } from 'firebase/firestore';
import { db } from '../lib/firebase';
import MetricCard from '../components/MetricCard';
import ParivatanScore from '../components/ParivatanScore';
import Sidebar from '../components/Sidebar';
import GenderDistributionChart from '../components/GenderDistributionChart';
import TopNavBar from '../components/TopNavBar';
import Filters, { FilterValues } from '../components/Filters';

export default function Dashboard() {
  const { colorMode, toggleColorMode } = useColorMode();
  const [filters, setFilters] = useState<FilterValues>({});
  const [metrics, setMetrics] = useState({
    electricityData: {
      totalUnits: 0,
      details: [] as { month: string; year: number; units: number }[]
    },
    waterData: {
      totalUnits: 0,
      details: [] as { period: string; units: number }[]
    },
    fuelData: {
      totalLitres: 0,
      details: [] as { billNumber: string; litres: number }[]
    },
    totalUsers: 0,
    genderDistribution: {
      male: 0,
      female: 0,
      others: 0
    }
  });

  const fetchData = async (currentFilters: FilterValues = {}) => {
    try {
      // Create base queries
      let postOfficesQuery = query(collection(db, 'postOffices'));
      let usersQuery = query(collection(db, 'users'), where('isEmployee', '==', true));

      // Apply filters
      if (currentFilters.circle) {
        postOfficesQuery = query(postOfficesQuery, where('circle', '==', currentFilters.circle));
      }

      if (currentFilters.employmentType) {
        usersQuery = query(usersQuery, where('employmentType', '==', currentFilters.employmentType));
      }

      if (currentFilters.gender) {
        usersQuery = query(usersQuery, where('gender', '==', currentFilters.gender));
      }

      if (currentFilters.casteCategory) {
        usersQuery = query(usersQuery, where('casteCategory', '==', currentFilters.casteCategory));
      }

      const [postOfficesSnapshot, usersSnapshot] = await Promise.all([
        getDocs(postOfficesQuery),
        getDocs(usersQuery)
      ]);

      let totalWaterUnits = 0;
      let totalFuelLitres = 0;
      let waterDetails: { period: string; units: number }[] = [];
      let fuelDetails: { billNumber: string; litres: number }[] = [];

      // Process post offices data
      for (const postOffice of postOfficesSnapshot.docs) {
        const postOfficeId = postOffice.id;

        try {
          // Get water bills
          const waterRef = collection(db, 'postOffices', postOfficeId, 'waterBills');
          const waterSnapshot = await getDocs(waterRef);
          
          waterSnapshot.forEach(doc => {
            const data = doc.data();
            if (data.unitsConsumed) {
              totalWaterUnits += Number(data.unitsConsumed);
              waterDetails.push({
                period: `${data.billingPeriodStart || ''} to ${data.billingPeriodEnd || ''}`,
                units: Number(data.unitsConsumed)
              });
            }
          });

          // Get fuel bills
          const fuelRef = collection(db, 'postOffices', postOfficeId, 'fuelBills');
          const fuelSnapshot = await getDocs(fuelRef);
          
          fuelSnapshot.forEach(doc => {
            const data = doc.data();
            if (data.litresConsumed) {
              totalFuelLitres += Number(data.litresConsumed);
              fuelDetails.push({
                billNumber: data.billNumber || doc.id,
                litres: Number(data.litresConsumed)
              });
            }
          });
        } catch (error) {
          console.error(`Error processing post office ${postOfficeId}:`, error);
          continue;
        }
      }

      // Process users data for gender distribution
      const genderCounts = {
        male: 0,
        female: 0,
        others: 0
      };

      usersSnapshot.forEach(doc => {
        const userData = doc.data();
        const gender = userData.gender?.toLowerCase() || 'others';
        genderCounts[gender]++;
      });

      // Update metrics state
      setMetrics(prevMetrics => ({
        ...prevMetrics,
        waterData: {
          totalUnits: totalWaterUnits,
          details: waterDetails
        },
        fuelData: {
          totalLitres: totalFuelLitres,
          details: fuelDetails
        },
        totalUsers: usersSnapshot.size,
        genderDistribution: genderCounts
      }));

    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  const handleFilterChange = (newFilters: FilterValues) => {
    setFilters(newFilters);
    fetchData(newFilters);
  };

  // Initial data fetch
  useEffect(() => {
    fetchData(filters);
  }, []);

  return (
    <Flex minH="100vh" bg={colorMode === 'dark' ? 'gray.900' : 'gray.100'}>
      <Sidebar
        darkMode={colorMode === 'dark'}
        onToggleDarkMode={toggleColorMode}
      />
      
      <Box ml="250px" p={8} w="full">
        <Filters onFilterChange={handleFilterChange} />
        
        <Box mt={16}>
          <Grid
            templateColumns="repeat(auto-fit, minmax(250px, 1fr))"
            gap={6}
            mb={8}
          >
            <MetricCard
              title="Energy Consumption"
              percentage={0}
              currentUsage={`${metrics.electricityData.totalUnits.toFixed(2)} kWh`}
              benchmark={`${metrics.electricityData.details.length} Bills`}
            />
            <MetricCard
              title="Water Consumption"
              percentage={0}
              currentUsage={`${metrics.waterData.totalUnits.toFixed(2)} m³`}
              benchmark={`${metrics.waterData.details.length} Bills`}
            />
            <MetricCard
              title="Fuel Consumption"
              percentage={0}
              currentUsage={`${metrics.fuelData.totalLitres.toFixed(2)} L`}
              benchmark={`${metrics.fuelData.details.length} Bills`}
            />
            <MetricCard
              title="Latest Records"
              percentage={0}
              currentUsage={metrics.electricityData.details[0]?.month || 'No Data'}
              benchmark={`Year: ${metrics.electricityData.details[0]?.year || 'N/A'}`}
            />
          </Grid>

          <Grid templateColumns="repeat(2, 1fr)" gap={6}>
            <ParivatanScore
              score={0}
              customerCount={metrics.totalUsers.toString()}
              satisfactionScore={0}
            />
            <GenderDistributionChart
              maleCount={metrics.genderDistribution.male}
              femaleCount={metrics.genderDistribution.female}
              othersCount={metrics.genderDistribution.others}
            />
          </Grid>
        </Box>
      </Box>
    </Flex>
  );
}