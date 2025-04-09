import React from 'react';
import {
  Box,
  Select,
  Stack,
  FormControl,
  FormLabel,
  Input,
  HStack,
  Button,
} from '@chakra-ui/react';

interface FiltersProps {
  onFilterChange: (filters: FilterValues) => void;
}

export interface FilterValues {
  circle?: string;
  region?: string;
  division?: string;
  employmentType?: string;
  gender?: string;
  casteCategory?: string;
  dateFrom?: string;
  dateTo?: string;
  energySource?: string;
}

const Filters: React.FC<FiltersProps> = ({ onFilterChange }) => {
  const [filters, setFilters] = React.useState<FilterValues>({});

  const handleFilterChange = (field: keyof FilterValues, value: string) => {
    const newFilters = { ...filters, [field]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };

  const handleReset = () => {
    setFilters({});
    onFilterChange({});
  };

  return (
    <Box p={4} bg="whiteAlpha.100" borderRadius="xl" mb={6}>
      <Stack spacing={4}>
        <HStack spacing={4}>
          <FormControl>
            <FormLabel color="gray.300">Circle</FormLabel>
            <Select
              value={filters.circle || ''}
              onChange={(e) => handleFilterChange('circle', e.target.value)}
              placeholder="All Circles"
              color="gray.300"
            >
              <option value="Tamilnadu">Tamil Nadu</option>
              <option value="Karnataka">Karnataka</option>
              <option value="Bihar">Bihar</option>
              <option value="Andhra Pradesh">Andhra Pradesh</option>
            </Select>
          </FormControl>

          <FormControl>
            <FormLabel color="gray.300">Employment Type</FormLabel>
            <Select
              value={filters.employmentType || ''}
              onChange={(e) => handleFilterChange('employmentType', e.target.value)}
              placeholder="All Types"
              color="gray.300"
            >
              <option value="Permanent">Permanent</option>
              <option value="Contractual">Contractual</option>
            </Select>
          </FormControl>

          <FormControl>
            <FormLabel color="gray.300">Gender</FormLabel>
            <Select
              value={filters.gender || ''}
              onChange={(e) => handleFilterChange('gender', e.target.value)}
              placeholder="All Genders"
              color="gray.300"
            >
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Others">Others</option>
            </Select>
          </FormControl>
        </HStack>

        <HStack spacing={4}>
          <FormControl>
            <FormLabel color="gray.300">Caste Category</FormLabel>
            <Select
              value={filters.casteCategory || ''}
              onChange={(e) => handleFilterChange('casteCategory', e.target.value)}
              placeholder="All Categories"
              color="gray.300"
            >
              <option value="General">General</option>
              <option value="OBC">OBC</option>
              <option value="SC">SC</option>
              <option value="ST">ST</option>
            </Select>
          </FormControl>

          <FormControl>
            <FormLabel color="gray.300">Date From</FormLabel>
            <Input
              type="date"
              value={filters.dateFrom || ''}
              onChange={(e) => handleFilterChange('dateFrom', e.target.value)}
              color="gray.300"
            />
          </FormControl>

          <FormControl>
            <FormLabel color="gray.300">Date To</FormLabel>
            <Input
              type="date"
              value={filters.dateTo || ''}
              onChange={(e) => handleFilterChange('dateTo', e.target.value)}
              color="gray.300"
            />
          </FormControl>
        </HStack>

        <Button onClick={handleReset} colorScheme="blue" size="sm">
          Reset Filters
        </Button>
      </Stack>
    </Box>
  );
};

export default Filters; 