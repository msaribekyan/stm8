#include "stm8s003.h"
#include "clock.h"

static void UART1_ClearIdle(void)
{
    volatile unsigned char tmp;

    tmp = USART1_SR;  // MUST read SR first
    tmp = USART1_DR;  // THEN read DR
    (void)tmp;
}

void uart_write_c(unsigned char c)
{
	while(!(USART1_SR & USART_SR_TXE));
	USART1_DR = c;
}

void uart_write(const char *str)
{
	while(*str)
	{
		uart_write_c(*str);
		str++;
	}
}

unsigned char uart_read(unsigned char *buf, unsigned char len)
{
	unsigned char i;
	unsigned char data;

	i = 0;
	while (1)
	{
		if (USART1_SR & USART_SR_RXNE)	// Data register not empty
		{
			data = USART1_DR;	// clear RXNE
			if (i < len)
			{
				buf[i] = data;
				i++;
			}
		}
		if (USART1_SR & USART_SR_IDLE)
		{
			UART1_ClearIdle();
			//(void)USART1_SR;	// Empty read to clear the idle line
			//(void)USART1_DR;	// Empty read to clear the idle line
			break;
		}
	}
	buf[i] = '\0';
	return (i);
}

void delay_ms(unsigned long ms)
{
	unsigned long cycles = 1318 * ms;
	while(cycles--);
}

int main(void)
{
	int		i;
	unsigned char	buf[20] = {0};
	CLK_CKDIVR = 0x00;
	CLK_PCKENR1 = 0xFF; // Enable peripherals

	//PC_DDR = 0x08; // Put TX line on
	//PC_CR1 = 0x08;

	USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
	USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
	USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	
	while(1)
	{

		i = uart_read((unsigned char *) buf, 20);
		if (i)
			uart_write((unsigned char *) buf);
		i = 0;
		while (i < 20)
			buf[i--] = 0;
		uart_write("Nothing\n");
		delay_ms(1000);
	}
}
