//UP COUNTER of 4 digits. 
//The counter counts numbers from 0000H to FFFFH and increments at every 0.5 sec. 
//crystal frequency of 12MHZ.

ORG 0000H             
MOV DPTR, #ASCII_TABLE 

MAIN:
    MOV A, #30H       ; LCD 8-bit mode 
    ACALL CONWRT      
    ACALL DELAY       
    MOV A, #0EH       ; Display ON, cursor ON
    ACALL CONWRT
    ACALL DELAY
    MOV A, #06H       ; Entry mode set, cursor increment
    ACALL CONWRT
    ACALL DELAY
    MOV A, #01H       ; Clear
    ACALL CONWRT
    ACALL DELAY
    MOV A, #80H       ; Set cursor to the first line, first column
    ACALL CONWRT
    ACALL DELAY

    MOV R6, #00H      ; LSB
    MOV R7, #00H      
    MOV R1, #00H      
    MOV R2, #00H      ; MSB of the counter

CounterLoop:
    MOV A, R2         
    ACALL DisplayHex  
    MOV A, R1         
    ACALL DisplayHex  
    MOV A, R7         
    ACALL DisplayHex  
    MOV A, R6         
    ACALL DisplayHex  
    ACALL DELAY       

    MOV A, #01H       ; Clear the LCD
    ACALL CONWRT
    ACALL DELAY
    MOV A, #80H       ; Reset cursor position to beginning
    ACALL CONWRT
    ACALL DELAY

    INC R6            
    CJNE R6, #10H, NotReset0  ; If LSB < 0x10, skip reset
    MOV R6, #00H      
    INC R7            
    CJNE R7, #10H, NotReset1  
    MOV R7, #00H      
    INC R1            
    CJNE R1, #10H, NotReset2  
    MOV R1, #00H      
    INC R2            
    CJNE R2, #10H, NotReset3  ; If MSB < 0x10, skip reset
    MOV R2, #00H      

NotReset0:
NotReset1:
NotReset2:
NotReset3:
    SJMP CounterLoop  ; Loop back for next value

DisplayHex:
    MOVC A, @A+DPTR   
    ACALL DATAWRT    
    RET
DATAWRT:			  ; To Write data  
    MOV P1, A         
    SETB P2.0         ; Set RS for data mode
    CLR P2.1          ; Set RW for write mode
    SETB P2.2         ; Enable high to latch data
    ACALL DELAY       
    CLR P2.2          ; Set Enable low
    RET
CONWRT:				  ; To Write command to LCD
    MOV P1, A         
    CLR P2.0           
    CLR P2.1         
    SETB P2.2         ; Enable high 
    ACALL DELAY       
    CLR P2.2          ; Set Enable low 
    RET

DELAY:				  ; Delay function
    MOV R3, #50       
HERE2:
    MOV R4, #255      
HERE1:
    DJNZ R4, HERE1    
    DJNZ R3, HERE2    
    RET

ASCII_TABLE:
    DB '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'

END                 
