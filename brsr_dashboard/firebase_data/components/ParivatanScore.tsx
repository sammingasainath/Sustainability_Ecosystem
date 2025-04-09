import React from 'react';
import { Box, Text, VStack, HStack, Icon } from '@chakra-ui/react';
import { FaUsers, FaChartLine } from 'react-icons/fa';

interface ParivatanScoreProps {
  score: number;
  customerCount: string;
  satisfactionScore: number;
}

const ParivatanScore: React.FC<ParivatanScoreProps> = ({
  customerCount,
}) => {
  return (
    <Box
      bg="whiteAlpha.100"
      borderRadius="xl"
      p={6}
      w="100%"
      boxShadow="0 4px 6px rgba(0, 0, 0, 0.1)"
      transition="transform 0.2s"
      _hover={{ transform: 'translateY(-2px)' }}
    >
      <VStack align="stretch" spacing={6}>
        <HStack spacing={3}>
          <Icon as={FaChartLine} color="green.400" boxSize={5} />
          <Text fontSize="2xl" color="gray.300" fontWeight="medium">
            Overall Statistics
          </Text>
        </HStack>
        
        <HStack spacing={8} align="flex-start">
          <Box flex={1}>
            <HStack spacing={3} mb={2}>
              <Icon as={FaUsers} color="green.400" boxSize={4} />
              <Text fontSize="sm" color="gray.400">Total Employees</Text>
            </HStack>
            <Text fontSize="3xl" color="gray.300" fontWeight="bold">
              {customerCount}
            </Text>
          </Box>
        </HStack>
      </VStack>
    </Box>
  );
};

export default ParivatanScore; 