LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TOP_LEVEL IS
    PORT(
        CLK50MHZ : IN  STD_LOGIC;
          
        -- BUTTONS ACTIVE IN LOW
        MOVE_LEFT : IN  STD_LOGIC;
        MOVE_RIGHT : IN  STD_LOGIC;
        SHOOT : IN  STD_LOGIC;
          
        -- UART
        TX_UART : OUT STD_LOGIC;
          
        -- LEDS
        LED_LEFT : OUT STD_LOGIC;
        LED_RIGHT : OUT STD_LOGIC;
        LED_SHOOT : OUT STD_LOGIC;
          
        -- LEDS Z
        LED_Z : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END TOP_LEVEL;

ARCHITECTURE BEHAV OF TOP_LEVEL IS
     -- UART CLK SIGNALS (9600)
    SIGNAL CLK_COUNTER : INTEGER := 0;
    SIGNAL UART_CLK : STD_LOGIC := '0';
    
    -- UART FSM
    TYPE UART_STATE IS (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    SIGNAL CURRENT_STATE : UART_STATE := IDLE;
    
    -- STATE DETECTION (PREVIOUS AND CURRECT)
    SIGNAL MOVE_LEFT_STATE : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11"; -- LOW ACTIVE
    SIGNAL MOVE_RIGHT_STATE : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";
    SIGNAL SHOOT_STATE : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";
     
    SIGNAL TX_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL TX_READY : STD_LOGIC := '0';
    SIGNAL TX_BUSY : STD_LOGIC := '0';
    
BEGIN

-- =========================================================
-- CLK GENERATOR 96000
-- =========================================================
CLK_9600: PROCESS(CLK50MHZ)
BEGIN
    IF (RISING_EDGE(CLK50MHZ)) THEN
        IF (CLK_COUNTER = (50000000 / (2 * 9600)) - 1) THEN
            UART_CLK   <= NOT UART_CLK;
            CLK_COUNTER <= 0;
        ELSE
            CLK_COUNTER <= CLK_COUNTER + 1;
        END IF;
	 ELSE
		UART_CLK <= UART_CLK;
		CLK_COUNTER <= CLK_COUNTER;
    END IF;
END PROCESS;

-- =========================================================
-- SYNCHRONIZATION AND BUTTONS DETECTION
-- =========================================================
BUTTON_SYNC: PROCESS(UART_CLK)
BEGIN
    IF (RISING_EDGE(UART_CLK)) THEN
        -- SYNCHRONIZE BUTTONS
        MOVE_LEFT_STATE <= MOVE_LEFT_STATE(0)  & MOVE_LEFT;
        MOVE_RIGHT_STATE <= MOVE_RIGHT_STATE(0) & MOVE_RIGHT;
        SHOOT_STATE <= SHOOT_STATE(0)      & SHOOT;
        
        -- DETECT LOW ACTIVATION
        IF (MOVE_LEFT_STATE = "10") THEN
            TX_DATA <= "01001100";  -- ASCII 'L'
            TX_READY <= '1';
        ELSIF (MOVE_RIGHT_STATE = "10") THEN
            TX_DATA <= "01010010";  -- ASCII 'R'
            TX_READY <= '1';
        ELSIF (SHOOT_STATE = "10") THEN
            TX_DATA <= "01010011";  -- ASCII 'S'
            TX_READY <= '1';
        ELSE
            TX_READY <= '0';
        END IF;
	 ELSE
		MOVE_LEFT_STATE <= MOVE_LEFT_STATE;
      MOVE_RIGHT_STATE <= MOVE_RIGHT_STATE;
      SHOOT_STATE <= SHOOT_STATE;
      TX_DATA <= TX_DATA;
      TX_READY <= TX_READY;
	 
    END IF;
END PROCESS;

-- =========================================================
-- FSM UART TX
-- =========================================================
UART_TX: PROCESS(UART_CLK)
    VARIABLE BIT_INDEX : INTEGER RANGE 0 TO 7 := 0;
BEGIN
    IF (RISING_EDGE(UART_CLK)) THEN
        CASE CURRENT_STATE IS
            WHEN IDLE =>
                TX_UART <= '1';
                IF (TX_READY = '1' AND TX_BUSY = '0') THEN
                    TX_BUSY <= '1';
                    CURRENT_STATE <= START_BIT;
                END IF;
                
            WHEN START_BIT =>
                TX_UART <= '0'; 
                BIT_INDEX := 0;
                CURRENT_STATE <= DATA_BITS;
                
            WHEN DATA_BITS =>
                TX_UART <= TX_DATA(BIT_INDEX); 
                IF (BIT_INDEX = 7) THEN
                    CURRENT_STATE <= STOP_BIT;
                ELSE
                    BIT_INDEX := BIT_INDEX + 1;
                END IF;
                
            WHEN STOP_BIT =>
                TX_UART <= '1';
                TX_BUSY <= '0';
                CURRENT_STATE <= IDLE;
        END CASE;
    END IF;
END PROCESS;

-- =========================================================
-- LEDS
-- =========================================================
LED_LEFT <= NOT MOVE_LEFT;
LED_RIGHT <= NOT MOVE_RIGHT;
LED_SHOOT <= NOT SHOOT;

LED_Z(0) <= '0';
LED_Z(1) <= '0';
LED_Z(2) <= '0';
LED_Z(3) <= '0';
LED_Z(4) <= '0';
LED_Z(5) <= '0';
LED_Z(6) <= '0';


END BEHAV;
