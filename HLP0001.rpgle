   CTL-OPT DFTACTGRP(*NO) CCSID(*char:273);                             
***-------------------------------------------------------------------- 
***   AUTOR: CARLOS MAURICIO ESCOBAR AGUILAR                            
***   DESCRIPCION: DESPLIEGUE DE VENTANA DE GIRO DE EMPRESAS            
***-------------------------------------------------------------------- 
***   PARAMETRO DE SALIDA, RETORNA EL VALOR DEL GIRO SELECCIONADO       
***-------------------------------------------------------------------- 
     DCL-PI *N;                                                         
      WGROCOD PACKED(5:0);                                              
      WGRODES CHAR(40);                                                 
     END-PI;                                                            
***-------------------------------------------------------------------- 
***               PROGRAMAS A UTILIZAR                                  
***-------------------------------------------------------------------- 
     DCL-F   MAEGRO USAGE(*INPUT) KEYED;                                
     DCL-F   HLP0001FM WORKSTN SFILE(WDWSFL:RRN);                       
***-------------------------------------------------------------------- 
***                      VARIABLES                                      
***-------------------------------------------------------------------- 
     DCL-S   RRN       PACKED(5:0);                                     
***-------------------------------------------------------------------- 
***              INICIO DEL FLUJO DEL PROGRAMA                          
***-------------------------------------------------------------------- 
     DOW *IN03 = *OFF;                                                  
      SR_DATOS();                                                       
      EXFMT WDWCTL;                                                     
      Select;                                                           
       When *in03;                                                      
       Other;                                                           
        PR_OPCION();                                                    
       Endsl;                                                           
     ENDDO;                                                             
     *INLR = *ON;                                                       
**----------------------------------------------------------            
** EJECUTA SUBRUTINA DATOS                                              
**----------------------------------------------------------            
     DCL-PROC SR_DATOS;                                                 
  // Inicializa el Subfile                                              
       *IN16 = *ON;       
       WRITE WDWCTL;                                      
       CLEAR WDWOPC;                                      
       *IN16 = *OFF;                                      
       *IN17 = *OFF;                                      
       RRN = 1;                                           
       *in12=*Off;                                        
       *IN01 = *OFF;                                      
  // Llena el Subfile.                                    
       SETLL *START MAEGRO;                               
       READ(N) MAEGRO;                                    
        DOW NOT %EOF(MAEGRO);                             
         RRN +=1;                                         
         WRITE WDWSFL;                                    
         READ MAEGRO;                                     
        ENDDO;                                            
 *// Evalua el despliegue del Subfile.                    
        IF RRN = 1;                                       
           *IN17 = *ON;                                   
        ENDIF;                                            
     END-PROC;          
**----------------------------------------------------------  
** EJECUTA SUBRUTINA SELECCION                                
**----------------------------------------------------------  
     DCL-PROC PR_OPCION;                                      
      RRN=1;                                                  
      CLEAR WGROCOD;                                          
      CLEAR WGRODES;                                          
      CHAIN RRN WDWSFL;                                       
      CHAIN(N) GROCOD MAEGRO;                                 
      Dow %found;                                             
       IF WDWOPC = 'X';                                       
          IF *IN01;                                           
           WGROCOD = GROCOD;                                  
           WGRODES = GRODES;                                  
           *IN03 = *ON;                                       
           RETURN;                                            
          ENDIF;                                              
       ENDIF;                                                                                           
       RRN+=1;       
       Chain RRN WDWSFL; 
       IF %FOUND;              
       CHAIN(N) GROCOD MAEGRO;
       ENDIF;                   
      Enddo;              
     RETURN;              
     END-PROC;                                                                                                                                     
