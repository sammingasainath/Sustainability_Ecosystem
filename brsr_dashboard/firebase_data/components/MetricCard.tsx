import React from 'react';
import { Box, Text, VStack, HStack, Icon } from '@chakra-ui/react';
import { FaBolt, FaWater, FaGasPump, FaRegClock } from 'react-icons/fa';
import { useRouter } from 'next/navigation';

interface MetricCardProps {
  title: string;
  percentage: number;
  currentUsage: string;
  benchmark: string;
}

const MetricCard: React.FC<MetricCardProps> = ({
  title,
  currentUsage,
  benchmark,
}) => {
  const router = useRouter();

  const getIcon = (title: string) => {
    switch (title) {
      case 'Energy Consumption':
        return FaBolt;
      case 'Water Consumption':
        return FaWater;
      case 'Fuel Consumption':
        return FaGasPump;
      case 'Latest Records':
        return FaRegClock;
      default:
        return FaBolt;
    }
  };

  const handleClick = () => {
    switch (title) {
      case 'Energy Consumption':
        router.push('/energy');
        break;
      // Add other cases for different pages
      default:
        break;
    }
  };

  return (
    <Box
      bg="whiteAlpha.100"
      borderRadius="xl"
      p={6}
      minW="200px"
      boxShadow="0 4px 6px rgba(0, 0, 0, 0.1)"
      transition="transform 0.2s"
      _hover={{ transform: 'translateY(-2px)', cursor: 'pointer' }}
      onClick={handleClick}
    >
      <VStack spacing={4} align="stretch">
        <HStack spacing={3}>
          <Icon as={getIcon(title)} color="green.400" boxSize={5} />
          <Text fontSize="lg" color="gray.300" fontWeight="medium">{title}</Text>
        </HStack>
        
        <Box>
          <Text fontSize="sm" color="gray.400" mb={2}>Current Usage</Text>
          <Text fontSize="2xl" color="green.400" fontWeight="bold">
            {currentUsage}
          </Text>
        </Box>

        <Box>
          <Text fontSize="sm" color="gray.400" mb={2}>Additional Info</Text>
          <Text fontSize="md" color="gray.300">
            {benchmark}
          </Text>
        </Box>
      </VStack>
    </Box>
  );
};

export default MetricCard; 