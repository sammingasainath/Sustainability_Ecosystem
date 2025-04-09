import React from 'react';
import { VStack, HStack, Box, Text, Icon, Switch, Image } from '@chakra-ui/react';
import { FaHome, FaChartBar, FaComments, FaFileAlt, FaUserCog, FaLink, FaSignOutAlt } from 'react-icons/fa';
import Link from 'next/link';

interface SidebarProps {
  darkMode: boolean;
  onToggleDarkMode: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ darkMode, onToggleDarkMode }) => {
  const menuItems = [
    { icon: FaHome, label: 'HomePage', href: '/' },
    { icon: FaChartBar, label: 'CSR Tool', href: '/csr' },
    { icon: FaComments, label: 'Dialogue', href: '/dialogue' },
    { icon: FaFileAlt, label: 'Policy Drafting', href: '/policy' },
    { icon: FaUserCog, label: 'Activity Tool', href: '/activity' },
    { icon: FaLink, label: 'LMS', href: '/lms' },
    { icon: FaChartBar, label: 'CSR & Subsidy', href: '/subsidy' },
  ];

  return (
    <Box
      h="100vh"
      w="250px"
      bg="whiteAlpha.50"
      p={4}
      position="fixed"
      left={0}
      top={0}
    >
      <VStack spacing={8} align="stretch">
        <Box>
          <Text fontSize="xl" fontWeight="bold" color="gray.300" mb={4}>
            Post4Planet
          </Text>
        </Box>

        <VStack spacing={2} align="stretch">
          {menuItems.map((item, index) => (
            <Link key={index} href={item.href} style={{ textDecoration: 'none' }}>
              <Box
                p={3}
                borderRadius="md"
                _hover={{ bg: 'whiteAlpha.200' }}
                cursor="pointer"
              >
                <HStack spacing={3}>
                  <Icon as={item.icon} color="gray.300" />
                  <Text color="gray.300">{item.label}</Text>
                </HStack>
              </Box>
            </Link>
          ))}
        </VStack>

        <Box mt="auto">
          <HStack justify="space-between" p={3}>
            <Text color="gray.300">Dark Mode</Text>
            <Switch
              isChecked={darkMode}
              onChange={onToggleDarkMode}
              colorScheme="green"
            />
          </HStack>

          <Box
            p={3}
            borderRadius="md"
            _hover={{ bg: 'whiteAlpha.200' }}
            cursor="pointer"
            mt={4}
            onClick={() => console.log('Logout clicked')}
          >
            <HStack spacing={3}>
              <Icon as={FaSignOutAlt} color="gray.300" />
              <Text color="gray.300">Logout</Text>
            </HStack>
          </Box>
        </Box>
      </VStack>
    </Box>
  );
};

export default Sidebar; 