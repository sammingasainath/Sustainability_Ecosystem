import React from 'react';
import { Box, HStack, Button, IconButton, Text, Tooltip } from '@chakra-ui/react';
import { FaBell, FaComments, FaCoins } from 'react-icons/fa';

const TopNavBar = () => {
  return (
    <Box
      position="fixed"
      top={0}
      right={0}
      p={4}
      pr={8}
      zIndex={10}
    >
      <HStack spacing={4}>
        <Tooltip label="Carbon Credits" placement="bottom">
          <Button
            leftIcon={<FaCoins />}
            colorScheme="green"
            variant="solid"
            size="sm"
            onClick={() => console.log('Carbon Credits clicked')}
          >
            Carbon Credits
          </Button>
        </Tooltip>

        <Tooltip label="Notifications" placement="bottom">
          <IconButton
            aria-label="Notifications"
            icon={<FaBell />}
            colorScheme="gray"
            variant="ghost"
            size="sm"
            position="relative"
            onClick={() => console.log('Notifications clicked')}
            _hover={{ bg: 'whiteAlpha.200' }}
          />
        </Tooltip>

        <Tooltip label="Chat" placement="bottom">
          <IconButton
            aria-label="Chat"
            icon={<FaComments />}
            colorScheme="gray"
            variant="ghost"
            size="sm"
            onClick={() => console.log('Chat clicked')}
            _hover={{ bg: 'whiteAlpha.200' }}
          />
        </Tooltip>
      </HStack>
    </Box>
  );
};

export default TopNavBar; 