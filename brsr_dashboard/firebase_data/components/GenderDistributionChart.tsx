import React from 'react';
import { Box, Text } from '@chakra-ui/react';
import { Pie } from 'react-chartjs-2';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';

ChartJS.register(ArcElement, Tooltip, Legend);

interface GenderDistributionProps {
  maleCount: number;
  femaleCount: number;
  othersCount: number;
}

const GenderDistributionChart: React.FC<GenderDistributionProps> = ({
  maleCount,
  femaleCount,
  othersCount,
}) => {
  const data = {
    labels: ['Male', 'Female', 'Others'],
    datasets: [
      {
        data: [maleCount, femaleCount, othersCount],
        backgroundColor: [
          'rgba(54, 162, 235, 0.8)',
          'rgba(255, 99, 132, 0.8)',
          'rgba(75, 192, 192, 0.8)',
        ],
        borderColor: [
          'rgba(54, 162, 235, 1)',
          'rgba(255, 99, 132, 1)',
          'rgba(75, 192, 192, 1)',
        ],
        borderWidth: 1,
      },
    ],
  };

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: 'bottom' as const,
        labels: {
          color: 'rgb(200, 200, 200)',
        },
      },
      title: {
        display: true,
        text: 'Employee Gender Distribution',
        color: 'rgb(200, 200, 200)',
        font: {
          size: 16,
        },
      },
    },
  };

  return (
    <Box
      bg="whiteAlpha.100"
      borderRadius="xl"
      p={6}
      w="100%"
      maxW="400px"
      maxH="400px"
    >
      <Pie data={data} options={options} />
      <Box mt={4}>
        <Text color="gray.300" fontSize="sm" textAlign="center">
          Total Employees: {maleCount + femaleCount + othersCount}
        </Text>
      </Box>
    </Box>
  );
};

export default GenderDistributionChart; 