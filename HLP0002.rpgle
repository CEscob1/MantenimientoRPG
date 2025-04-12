    CTL-OPT DFTACTGRP(*NO) CCSID(*char:273);                             
 ***-------------------------------------------------------------------- 
 ***   AUTOR: CARLOS MAURICIO ESCOBAR AGUILAR                            
 ***   DESCRIPCION: DESPLIEGUE DE VENTANA DE GIRO DE EMPRESAS            
 ***-------------------------------------------------------------------- 
 ***   PARAMETRO DE SALIDA, RETORNA EL VALOR DEL GIRO SELECCIONADO       
 ***-------------------------------------------------------------------- 
      DCL-PI *N;                                                         
       WCONCOD PACKED(5:0);                                              
       WCONNOM CHAR(50);                                                 
      END-PI;                                                            
 ***-------------------------------------------------------------------- 
 ***               PROGRAMAS A UTILIZAR                                  
 ***-------------------------------------------------------------------- 
      DCL-F   MAECON USAGE(*INPUT) KEYED;                                
      DCL-F   HLP0002FM WORKSTN SFILE(WDWSFL:RRN);                       
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
       RRN = 0;                                         
       *in12=*Off;                                      
       *IN01 = *OFF;                                    
  // Llena el Subfile.                                  
       SETLL *START MAECON;                             
       READ(N) MAECON;                                  
        DOW NOT %EOF(MAECON);                           
         RRN +=1;                                       
         WRITE WDWSFL;                                  
         READ MAECON;                                   
        ENDDO;                                          
 *// Evalua el despliegue del Subfile.                  
        IF RRN = 0;                                     
           *IN17 = *ON;                                 
        ENDIF;                                          
     END-PROC;     
 **----------------------------------------------------------  
 ** EJECUTA SUBRUTINA SELECCION                                
 **----------------------------------------------------------  
      DCL-PROC PR_OPCION;                                      
       RRN=1;                                                  
       CLEAR WCONCOD;                                          
       CLEAR WCONNOM;                                          
       CHAIN RRN WDWSFL;                                       
       CHAIN(N) CONCOD MAECON;                                 
       Dow %found;                                             
        IF WDWOPC = 'X';                                       
           IF *IN01;                                           
            WCONCOD = CONCOD;                                  
            WCONNOM = CONNOM;                                  
            *IN03 = *ON;                                       
            RETURN;                                            
           ENDIF;                                              
        ENDIF;                                                 
        *IN01 = *OFF;                                          
        RRN+=1;      
       Chain RRN WDWSFL;           
      Enddo;                       
     RETURN;                       
     END-PROC;                                                                                                                                                