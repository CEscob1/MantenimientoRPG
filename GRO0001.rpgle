   CTL-OPT DFTACTGRP(*NO) CCSID(*char:273);                            
***--------------------------------------------------------------------
***   AUTOR: CARLOS MAURICIO ESCOBAR AGUILAR                           
***   DESCRIPCION: MANTENIMIENTO DE GIRO DE EMPRESAS CON PANTALLAS     
***--------------------------------------------------------------------
***               PROGRAMAS A UTILIZAR                                 
***--------------------------------------------------------------------
     DCL-F   MAEGRO USAGE(*OUTPUT:*UPDATE:*DELETE) KEYED;              
     DCL-F   GRO0001FM WORKSTN SFILE(CRTSFL:RRN);                      
***--------------------------------------------------------------------
***                      VARIABLES                                     
***--------------------------------------------------------------------
     DCL-S   ERRARR     CHAR(70) DIM(5) CTDATA PERRCD(1);              
     DCL-S   RRN       PACKED(5:0);                                    
     DCL-S   wGRODES    CHAR(40);                                      
     DCL-S   wGROFEC   PACKED(12:0);                                   
     DCL-S   wGROUSE    CHAR(40);                                      
***--------------------------------------------------------------------
***              INICIO DEL FLUJO DEL PROGRAMA         
***-------------------------------------------------------------------- 
     DOW *IN03 = *OFF;                                                  
      SR_DATOS();                                                       
      WRITE CRTCMD;                                                     
      EXFMT CRTCTL;                                                     
      Select;                                                           
       When *in03;                                                      
       When *in06;                                                      
         PR_ALTA();                                                     
       Other;                                                           
         PR_CMD();                                                      
       Endsl;                                                           
     ENDDO;                                                             
     *INLR = *ON;                                                       
**----------------------------------------------------------            
** EJECUTA SUBRUTINA DATOS                                              
**----------------------------------------------------------            
     DCL-PROC SR_DATOS;                                                 
  // Inicializa el Subfile                                  
       WRITE CRTCTL;                                         
       CLEAR OP;                                             
       *IN93 = *OFF;                                         
       *IN92 = *OFF;                                         
       RRN = 0;                                              
       *in12=*Off;                                           
  // Llena el Subfile.                                       
       SETLL *START MAEGRO;                                  
       READ(N) MAEGRO;                                       
        DOW NOT %EOF(MAEGRO);                                
         RRN +=1;                                            
         WRITE CRTSFL;                                       
         READ MAEGRO;                                        
        ENDDO;                                               
 *// Evalua el despliegue del Subfile.                       
        IF RRN = 0;                                          
           *IN92 = *ON;                                      
        ENDIF;                                               
     END-PROC;                                               
**---------------------------------------------------------- 
** EJECUTA PROCEDIMIENTO ADICIONA                                       
**--------------------------------------------------------------------- 
    DCL-PROC PR_ALTA;                                                   
       clear crtalt;                                                    
       DOW *IN12 = *OFF;                                                
        EXFMT CRTALT;                                                   
         PR_VALIDA();                                                   
         IF ERRMSG = *BLANKS;                                           
          Chain(n) GROCOD MAEGRO;                                       
           If Not %found;                                               
           IF *IN01 = *ON;                                              
            WRITE RMAEGRO;                                              
            LEAVE;                                                      
           ENDIF;                                                       
           *IN01 = *OFF;                                                
           Endif;                                                       
         ENDIF;                                                         
       ENDDO;                                                           
    END-PROC;                                                           
**--------------------------------------------------------------------- 
** EJECUTA PROCEDIMIENTO MODIFICA                                       
**--------------------------------------------------------------------- 
    DCL-PROC PR_MODIFICA;                                               
      Chain(n) GROCOD MAEGRO;                                           
      DOW *IN12 = *OFF;                                                 
       EXFMT CRTMOD;                                                    
       PR_VALIDA();                                                     
        IF ERRMSG = *BLANKS;                                            
          wGRODES=GRODES;                                               
          wGROFEC=GROFEC;                                               
          wGROUSE=GROUSE;                                               
         Chain GROCOD MAEGRO;                                           
         If %found;                                                     
          IF *IN01 = *ON;                                               
           GRODES=wGRODES;                                              
           GROFEC=wGROFEC;                                              
           GROUSE=wGROUSE;                                              
           UPDATE RMAEGRO;                                              
           LEAVE;                                                       
          ENDIF;                            
          *IN01 = *OFF;                                                
         ENDIF;                                                        
        Endif;                                                         
      ENDDO;                                                           
    END-PROC;                                                          
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO ELIMINA                                       
**---------------------------------------------------------------------
    DCL-PROC PR_ELIMINA;                                               
     Chain(n) GROCOD MAEGRO;                                           
     DOW *IN12 = *OFF;                                                 
       EXFMT CRTDEL;                                                   
        IF *IN11;                                                      
         Chain GROCOD MAEGRO;                                          
          If %found;                                                   
           DELETE RMAEGRO;                                             
           LEAVE;                                                      
          Endif;                                                       
        ENDIF;                                                         
     ENDDO;                                         
     *in11=*off;                                                        
    END-PROC;                                                           
**--------------------------------------------------------------------- 
** EJECUTA PROCEDIMIENTO VALIDA                                         
**--------------------------------------------------------------------- 
    DCL-PROC PR_VALIDA;                                                 
                                                                        
     CLEAR ERRMSG;                                                      
     *IN25 = *OFF;                                                      
     *IN26 = *OFF;                                                      
     *IN27 = *OFF;                                                      
     *IN28 = *OFF;                                                      
     *IN29 = *OFF;                                                      
                                                                        
       IF GROCOD = *ZEROS;                                              
        *IN25 = *ON;                                                    
        ERRMSG = ERRARR(1);                                             
        RETURN;                                                         
       ENDIF;                  
       IF GRODES = *BLANKS;                                       
        *IN26 = *ON;                                              
        ERRMSG = ERRARR(2);                                       
        RETURN;                                                   
       ENDIF;                                                     
                                                                  
       IF GROHRA <> *ZEROS;                                       
        IF %DEC(%SUBST(%CHAR(GROHRA): 1:2): 2 : 0) > 24;          
        *IN27 = *ON;                                              
         ERRMSG = ERRARR(3);                                      
         RETURN;                                                  
        ENDIF;                                                    
                                                                  
        IF %DEC(%SUBST(%CHAR(GROHRA): 3:2): 2 : 0) > 60;          
         *IN27 = *ON;                                             
         ERRMSG = ERRARR(3);                                      
         RETURN;                                                  
        ENDIF;                                                    
       ENDIF;                     
       IF GROFEC <> *ZEROS;                                            
        TEST(DE) *ISO GROFEC;                                          
         IF (%ERROR);                                                  
          *IN28 = *ON;                                                 
          ERRMSG = ERRARR(4);                                          
         ENDIF;                                                        
       ENDIF;                                                          
                                                                       
       IF GROUSE = *BLANKS;                                            
        *IN29 = *ON;                                                   
        ERRMSG = ERRARR(5);                                            
        RETURN;                                                        
       ENDIF;                                                          
                                                                       
                                                                       
         RETURN;                                                       
    END-PROC;                                                          
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO OPCIONES DE USUARIO                           
**---------------------------------------------------------------------  
  DCL-PROC PR_CMD;                                                        
   RRN=1;                                                                 
   Chain RRN CRTSFL;                                                      
    Dow %found;                                                           
    Select;                                                               
     When OP = 'M';                                                       
      PR_MODIFICA();                                                      
     When OP = 'C';                                                       
      PR_CONSULTA();                                                      
     When OP = 'D';                                                       
      PR_ELIMINA();                                                       
     EndSL;                                                               
    RRN+=1;                                                               
    Chain RRN CRTSFL;                                                     
    Enddo;                                                                
  END-PROC;                                                               
**---------------------------------------------------------------------   
** EJECUTA PROCEDIMIENTO CONSULTA                                         
**---------------------------------------------------------------------   
    DCL-PROC PR_CONSULTA;    
      Chain(n) GROCOD MAEGRO;  
      DOW *IN12 = *OFF;        
       EXFMT CRTCON;           
      ENDDO;                   
      RETURN;                  
     END-PROC;                                             
**                             
NUMERO DE GIRO EN BLANCO       
CAMPO DE DESCRIPCION EN BLANCO 
FECHA DE CREACION NO VALIDA    
HORA DE CREACION NO VALIDA     
NOMBRE DE USUARIO EN BLANCO                                                                                                                                                                                                     