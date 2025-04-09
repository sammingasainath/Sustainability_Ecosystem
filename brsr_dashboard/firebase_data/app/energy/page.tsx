'use client';

import React, { useEffect, useState } from 'react';
import { Box, Text, Table, Thead, Tbody, Tr, Th, Td, VStack, useColorMode, HStack } from '@chakra-ui/react';
import { Line, Pie } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  ArcElement
} from 'chart.js';
import Sidebar from '../../components/Sidebar';
import { db } from '../../lib/firebase';
import { collection, getDocs, query, doc, getDoc } from 'firebase/firestore';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  ArcElement
);

interface ApplianceData {
  device_name: string;
  device_id: string;
  user_id: string;
  on_timestamp: { seconds: number };
  off_timestamp?: { seconds: number };
  wattage: number;
}

interface UserData {
  name: string;
  id: string;
}

interface ConsolidatedApplianceData {
  deviceName: string;
  userName: string;
  operationTime: string;
  energyConsumed: string;
  status: string;
  latestTimestamp: number;
}

interface EnergySourceData {
  nonRenewable: number;
  renewable: number;
  purchased: number;
}

interface ElectricityBill {
  unitsConsumed: number;
  billingMonth: string;
  year: number;
}

interface EmissionData {
  source: string;
  totalUsage: number;
  emissionFactor: string;
  totalEmission: string;
  benchmark: string;
}

export default function EnergyPage() {
  const { colorMode, toggleColorMode } = useColorMode();
  const [activeDevices, setActiveDevices] = useState<any[]>([]);
  const [totalWattage, setTotalWattage] = useState(0);
  const [userCache, setUserCache] = useState<{ [key: string]: string }>({});
  const [chartData, setChartData] = useState({
    labels: [],
    datasets: [
      {
        label: 'Live Load',
        data: [],
        fill: true,
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        tension: 0.4,
      },
    ],
  });
  const [applianceUsage, setApplianceUsage] = useState<Array<{
    deviceName: string;
    userName: string;
    operationTime: string;
    energyConsumed: number;
    status: string;
  }>>([]);
  const [energySourceData, setEnergySourceData] = useState<EnergySourceData>({
    nonRenewable: 0,
    renewable: 0,
    purchased: 0
  });
  const [emissionsData, setEmissionsData] = useState<EmissionData[]>([]);

  const calculateDeviceEnergy = (device: ApplianceData): number => {
    const onTime = device.on_timestamp.seconds;
    const offTime = device.off_timestamp ? device.off_timestamp.seconds : Math.floor(Date.now() / 1000);
    const operationTimeHours = (offTime - onTime) / 3600; // Convert seconds to hours
    const energyConsumed = (device.wattage / 1000) * operationTimeHours; // Convert wattage to kW and multiply by hours
    return energyConsumed;
  };

  const calculateOperationTime = (onTimestamp: number, offTimestamp?: number): string => {
    const start = new Date(onTimestamp * 1000);
    const end = offTimestamp ? new Date(offTimestamp * 1000) : new Date();
    const diffHours = (end.getTime() - start.getTime()) / (1000 * 60 * 60);
    return diffHours.toFixed(1) + 'hr';
  };

  const fetchUserName = async (userId: string): Promise<string> => {
    // Check cache first
    if (userCache[userId]) {
      return userCache[userId];
    }

    try {
      const userDoc = await getDoc(doc(db, 'users', userId));
      if (userDoc.exists()) {
        const userData = userDoc.data() as UserData;
        // Update cache
        setUserCache(prev => ({ ...prev, [userId]: userData.name }));
        return userData.name;
      }
      return userId; // Fallback to ID if user not found
    } catch (error) {
      console.error('Error fetching user:', error);
      return userId; // Fallback to ID on error
    }
  };

  const calculateEmissions = (
    nonRenewableEnergy: number,
    purchasedEnergy: number,
    renewableEnergy: number
  ): EmissionData[] => {
    return [
      {
        source: 'Energy from Non-Renewable Source',
        totalUsage: nonRenewableEnergy,
        emissionFactor: '2.75 kg CO2/kWh (Direct)',
        totalEmission: `${(nonRenewableEnergy * 2.75).toFixed(2)}g CO2/h`,
        benchmark: 'Active'
      },
      {
        source: 'Energy from Purchased Electricity',
        totalUsage: purchasedEnergy,
        emissionFactor: '0.71 kg CO2/kWh',
        totalEmission: `${(purchasedEnergy * 0.71).toFixed(2)} g/g CO2/h`,
        benchmark: 'Active'
      },
      {
        source: 'Energy from Renewable Source',
        totalUsage: renewableEnergy,
        emissionFactor: '0.01 kg CO2/kWh',
        totalEmission: `${(renewableEnergy * 0.01).toFixed(2)}`,
        benchmark: 'Active'
      }
    ];
  };

  const fetchAndUpdateData = async () => {
    try {
      // Fetch appliances data
      const appliancesSnapshot = await getDocs(query(collection(db, 'appliancesOn')));
      const devices = appliancesSnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      })) as ApplianceData[];

      // Calculate non-renewable energy from device_2
      const device2Data = devices.filter(device => device.device_id === 'device_2');
      let nonRenewableEnergy = 0;

      device2Data.forEach(device => {
        const onTime = device.on_timestamp.seconds;
        const offTime = device.off_timestamp ? device.off_timestamp.seconds : Math.floor(Date.now() / 1000);
        const operationTimeHours = (offTime - onTime) / 3600; // Convert seconds to hours
        const deviceEnergy = (device.wattage / 1000) * operationTimeHours; // Convert wattage to kW and multiply by hours
        nonRenewableEnergy += deviceEnergy;
      });

      // Fetch purchased electricity and solar units
      const postOfficesSnapshot = await getDocs(collection(db, 'postOffices'));
      let totalPurchasedUnits = 0;
      let totalSolarUnits = 0;

      await Promise.all(postOfficesSnapshot.docs.map(async postOffice => {
        const data = postOffice.data();
        
        // Get solar units
        if (data.solarUnits) {
          totalSolarUnits += data.solarUnits;
        }

        // Get electricity bills
        const electricityBillsRef = collection(doc(db, 'postOffices', postOffice.id), 'electricityBills');
        const billsSnapshot = await getDocs(electricityBillsRef);
        
        billsSnapshot.forEach(bill => {
          const billData = bill.data() as ElectricityBill;
          totalPurchasedUnits += billData.unitsConsumed || 0;
        });
      }));

      // Update energy source data
      setEnergySourceData({
        purchased: totalPurchasedUnits,
        nonRenewable: nonRenewableEnergy,
        renewable: totalSolarUnits
      });

      // Calculate and update emissions data
      const emissions = calculateEmissions(
        nonRenewableEnergy,
        totalPurchasedUnits,
        totalSolarUnits
      );
      setEmissionsData(emissions);

      // Process data for appliance usage table
      const uniqueUserIds = Array.from(new Set(devices.map(device => device.user_id)));
      const userNamesMap: { [key: string]: string } = {};
      
      await Promise.all(uniqueUserIds.map(async userId => {
        const userName = await fetchUserName(userId);
        userNamesMap[userId] = userName;
      }));

      // Map devices with calculated energy consumption
      const consolidatedData = devices.map(device => {
        const userName = userNamesMap[device.user_id] || device.user_id;
        const operationTime = calculateOperationTime(
          device.on_timestamp.seconds,
          device.off_timestamp?.seconds
        );

        // Calculate energy consumed for each device
        const onTime = device.on_timestamp.seconds;
        const offTime = device.off_timestamp ? device.off_timestamp.seconds : Math.floor(Date.now() / 1000);
        const operationTimeHours = (offTime - onTime) / 3600;
        const energyConsumed = (device.wattage / 1000) * operationTimeHours;

        return {
          deviceName: device.device_name,
          userName,
          operationTime,
          energyConsumed: energyConsumed.toFixed(1),
          status: device.off_timestamp ? 'Off' : 'Active',
          latestTimestamp: device.on_timestamp.seconds
        };
      });

      // Group by device name and keep the most recent
      const deviceMap = new Map();
      consolidatedData.forEach(device => {
        const existing = deviceMap.get(device.deviceName);
        if (!existing || device.latestTimestamp > existing.latestTimestamp) {
          deviceMap.set(device.deviceName, device);
        }
      });

      setApplianceUsage(Array.from(deviceMap.values()));

      // Update active devices and total wattage
      const currentlyActive = devices.filter(device => 
        device.on_timestamp && !device.off_timestamp
      );
      setActiveDevices(currentlyActive);
      const currentTotalWattage = currentlyActive.reduce((sum, device) => sum + (device.wattage || 0), 0);
      setTotalWattage(currentTotalWattage);

      // Process data for chart
      if (currentlyActive.length > 0) {
        // Get earliest and latest timestamps
        const timestamps = currentlyActive.map(d => d.on_timestamp.seconds * 1000);
        const earliestTime = new Date(Math.min(...timestamps));
        const latestTime = new Date();

        // Create time points every 5 minutes between earliest and latest
        const timePoints = [];
        const currentTime = new Date(earliestTime);
        while (currentTime <= latestTime) {
          timePoints.push(new Date(currentTime));
          currentTime.setMinutes(currentTime.getMinutes() + 5);
        }

        // Format labels in IST
        const labels = timePoints.map(time => 
          time.toLocaleTimeString('en-IN', { 
            timeZone: 'Asia/Kolkata',
            hour: '2-digit',
            minute: '2-digit'
          })
        );

        // Calculate total wattage at each time point
        const data = timePoints.map(time => {
          const activeAtTime = currentlyActive.filter(device => 
            new Date(device.on_timestamp.seconds * 1000) <= time
          );
          return activeAtTime.reduce((sum, device) => sum + (device.wattage || 0), 0);
        });

        setChartData(prev => ({
          ...prev,
          labels,
          datasets: [{
            ...prev.datasets[0],
            data
          }]
        }));
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  useEffect(() => {
    // Initial fetch
    fetchAndUpdateData();

    // Set up 5-second interval
    const intervalId = setInterval(fetchAndUpdateData, 5000);

    // Cleanup interval on component unmount
    return () => clearInterval(intervalId);
  }, []);

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top' as const,
        labels: {
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
      },
      title: {
        display: true,
        text: 'Live Load (Wattage)',
        color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        font: {
          size: 16,
        },
      },
    },
    scales: {
      y: {
        beginAtZero: true,
        title: {
          display: true,
          text: 'Wattage',
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
        grid: {
          color: colorMode === 'dark' ? 'rgba(200, 200, 200, 0.1)' : 'rgba(0, 0, 0, 0.1)',
        },
        ticks: {
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
      },
      x: {
        title: {
          display: true,
          text: 'Time (IST)',
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
        grid: {
          color: colorMode === 'dark' ? 'rgba(200, 200, 200, 0.1)' : 'rgba(0, 0, 0, 0.1)',
        },
        ticks: {
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
      },
    },
  };

  const pieChartData = {
    labels: ['Energy from Purchased Electricity', 'Energy from Non-Renewable Source', 'Energy from Renewable Source'],
    datasets: [
      {
        data: [
          energySourceData.purchased,
          energySourceData.nonRenewable,
          energySourceData.renewable
        ],
        backgroundColor: [
          'rgb(255, 205, 86)',  // Yellow for Purchased
          'rgb(255, 99, 132)',  // Red for Non-Renewable
          'rgb(75, 192, 192)',  // Green for Renewable
        ],
        borderColor: [
          'rgb(255, 205, 86)',
          'rgb(255, 99, 132)',
          'rgb(75, 192, 192)',
        ],
        borderWidth: 1,
      },
    ],
  };

  const pieChartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: 'right' as const,
        labels: {
          color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        },
      },
      title: {
        display: true,
        text: 'Energy by Source',
        color: colorMode === 'dark' ? 'rgb(200, 200, 200)' : 'rgb(50, 50, 50)',
        font: {
          size: 16,
        },
      },
    },
  };

  return (
    <Box minH="100vh" bg={colorMode === 'dark' ? 'gray.900' : 'gray.100'}>
      <Sidebar darkMode={colorMode === 'dark'} onToggleDarkMode={toggleColorMode} />
      
      <Box ml="250px" p={8}>
        <VStack spacing={8} align="stretch">
          {/* Live Load Section */}
          <Box>
            <Text fontSize="2xl" color={colorMode === 'dark' ? 'gray.300' : 'gray.700'} mb={2}>Live Load</Text>
            <Text fontSize="lg" color={colorMode === 'dark' ? 'gray.400' : 'gray.600'} mb={4}>
              {totalWattage} Watts
            </Text>
            <Box 
              bg={colorMode === 'dark' ? 'whiteAlpha.100' : 'white'} 
              p={6} 
              borderRadius="xl" 
              height="300px"
              boxShadow="sm"
            >
              <Line options={chartOptions} data={chartData} />
            </Box>
          </Box>

          {/* Energy by Source Pie Chart */}
          <Box>
            <Text fontSize="2xl" color={colorMode === 'dark' ? 'gray.300' : 'gray.700'} mb={4}>
              Energy Distribution
            </Text>
            <Box 
              bg={colorMode === 'dark' ? 'whiteAlpha.100' : 'white'} 
              p={6} 
              borderRadius="xl"
              height="400px"
              boxShadow="sm"
            >
              <Pie data={pieChartData} options={pieChartOptions} />
            </Box>
          </Box>

          {/* Usage by Appliances Section */}
          <Box>
            <Text fontSize="2xl" color={colorMode === 'dark' ? 'gray.300' : 'gray.700'} mb={4}>
              Usage by Appliances
            </Text>
            <Box overflowX="auto">
              <Table 
                variant="simple" 
                bg={colorMode === 'dark' ? 'whiteAlpha.100' : 'white'} 
                borderRadius="xl"
                boxShadow="sm"
              >
                <Thead>
                  <Tr>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Appliance Name</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>User Name</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Total Open Time</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Energy Consumed (Units)</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Status</Th>
                  </Tr>
                </Thead>
                <Tbody>
                  {applianceUsage.map((appliance, index) => (
                    <Tr key={index}>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{appliance.deviceName}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{appliance.userName}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{appliance.operationTime}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{appliance.energyConsumed}</Td>
                      <Td color={appliance.status === 'Active' ? 'green.400' : 'red.400'}>
                        {appliance.status}
                      </Td>
                    </Tr>
                  ))}
                </Tbody>
              </Table>
            </Box>
          </Box>

          {/* Emissions Table */}
          <Box>
            <Text fontSize="2xl" color={colorMode === 'dark' ? 'gray.300' : 'gray.700'} mb={4}>
              Emission by Source
            </Text>
            <Box overflowX="auto">
              <Table 
                variant="simple" 
                bg={colorMode === 'dark' ? 'whiteAlpha.100' : 'white'} 
                borderRadius="xl"
                boxShadow="sm"
              >
                <Thead>
                  <Tr>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Source Name</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Total Usage (KWh)</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Emission Factor (CO2/KWh)</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Total Emission (Kg CO2/h)</Th>
                    <Th color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>Benchmark (BEE)</Th>
                  </Tr>
                </Thead>
                <Tbody>
                  {emissionsData.map((item, index) => (
                    <Tr key={index}>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{item.source}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{item.totalUsage.toFixed(2)}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{item.emissionFactor}</Td>
                      <Td color={colorMode === 'dark' ? 'gray.300' : 'gray.700'}>{item.totalEmission}</Td>
                      <Td color="green.400">{item.benchmark}</Td>
                    </Tr>
                  ))}
                </Tbody>
              </Table>
            </Box>
          </Box>
        </VStack>
      </Box>
    </Box>
  );
} 