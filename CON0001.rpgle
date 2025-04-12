   CTL-OPT DFTACTGRP(*NO) CCSID(*char:273);                            
***--------------------------------------------------------------------
***   AUTOR: CARLOS MAURICIO ESCOBAR AGUILAR                           
***   DESCRIPCION: MANTENIMIENTO DE GIRO DE EMPRESAS CON PANTALLAS     
***--------------------------------------------------------------------
***               PROGRAMAS A UTILIZAR                                 
***--------------------------------------------------------------------
     DCL-F   MAECON USAGE(*OUTPUT:*UPDATE:*DELETE) KEYED;              
     DCL-F   CON0001FM WORKSTN SFILE(CRTSFL:RRN);                      
***--------------------------------------------------------------------
***                      VARIABLES                                     
***--------------------------------------------------------------------
     DCL-S   ERRARR     CHAR(70) DIM(9) CTDATA PERRCD(1);              
     DCL-S   RRN       PACKED(5:0);                                    
     DCL-S   wCONNOM    CHAR(50);                                      
     DCL-S   wCONAPE    CHAR(50);                                      
     DCL-S   wCONTEL   PACKED(10:0);                                   
     DCL-S   wCONCEL   PACKED(10:0);                                   
     DCL-S   wCONMAIL    CHAR(100);     
     DCL-S   wCONFEC   PACKED(8:0);                                    
     DCL-S   wCONHRA   PACKED(4:0);                                    
     DCL-S   wCONUSE     CHAR(40);                                     
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
        *IN93 = *ON;                                         
        WRITE CRTCTL;                                        
        CLEAR OP;                                            
        *IN93 = *OFF;                                        
        *IN92 = *OFF;                                        
        RRN = 0;                                             
        *in12=*Off;                                          
   // Llena el Subfile.                                      
        SETLL *START MAECON;                                 
        READ(N) MAECON;                                      
         DOW NOT %EOF(MAECON);                               
          RRN +=1;                                           
          WRITE CRTSFL;                                      
          READ MAECON;                                       
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
          Chain(n) CONCOD MAECON;                                      
           If Not %found;                                              
           IF *IN01 = *ON;                                             
            WRITE RMAECON;                                             
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
      Chain(n) CONCOD MAECON;                                          
      DOW *IN12 = *OFF;                                                
       EXFMT CRTMOD;                                                   
       PR_VALIDA();                                                    
        IF ERRMSG = *BLANKS;                                           
          wCONNOM =  CONNOM;                                           
          wCONAPE =  CONAPE;                                           
          wCONTEL =  CONTEL;                                           
          wCONCEL =  CONCEL;                                           
          wCONMAIL = CONMAIL;                                          
          wCONFEC =  CONFEC;                                           
          wCONHRA =  CONHRA;      
          wCONUSE =  CONUSE;                           
         Chain CONCOD MAECON;                          
         If %found;                                    
          IF *IN01 = *ON;                              
           CONNOM =  WCONNOM;                          
           CONAPE =  WCONAPE;                          
           CONTEL =  WCONTEL;                          
           CONCEL =  WCONCEL;                          
           CONMAIL = WCONMAIL;                         
           CONFEC = WCONFEC;                           
           CONHRA =  WCONHRA;                          
           CONUSE =  WCONUSE;                          
           UPDATE RMAECON;                             
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
     Chain(n) CONCOD MAECON;                                             
     DOW *IN12 = *OFF;                                                   
       EXFMT CRTDEL;                                                     
        IF *IN11;                                                        
         Chain CONCOD MAECON;                                            
          If %found;                                                     
           DELETE RMAECON;                                               
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
     *IN30 = *OFF;                               
     *IN31 = *OFF;                               
     *IN32 = *OFF;                               
     *IN33 = *OFF;                               
                                                 
       IF CONCOD = *ZEROS;                       
        *IN25 = *ON;                             
        ERRMSG = ERRARR(1);                      
        RETURN;                                  
       ENDIF;                                    
                                                 
       IF CONNOM = *BLANKS;                
        *IN26 = *ON;                            
        ERRMSG = ERRARR(2);                     
        RETURN;                                 
       ENDIF;                                   
                                                
       IF CONAPE = *BLANKS;                     
        *IN27 = *ON;                            
        ERRMSG = ERRARR(3);                     
        RETURN;                                 
       ENDIF;                                   
                                                
       IF CONTEL = *ZEROS;                      
        *IN28 = *ON;                            
        ERRMSG = ERRARR(4);                     
       ENDIF;                                   
                                                
       IF CONCEL = *ZEROS;                      
        *IN29 = *ON;                            
        ERRMSG = ERRARR(5);                     
       ENDIF;             
                                                                     
       IF COMP01 <> *BLANKS OR COMP02 <> *BLANKS;                    
        CONMAIL = %TRIM(COMP01) + %TRIM(COMP02);                     
                                                                     
        IF %SCAN(X'40' :%SUBST(CONMAIL: 1: %LEN(%TRIM(CONMAIL))))> 0;
             *IN30 = *ON;                                            
             ERRMSG = ERRARR(6);                                     
             RETURN;                                                 
        ENDIF;                                                       
                                                                     
        IF %SCAN(X'7C' : CONMAIL) = 0 OR                             
            %SCAN(X'7C' : CONMAIL : %SCAN(X'7C' : CONMAIL) + 1) > 0; 
             *IN30 = *ON;                                            
             ERRMSG = ERRARR(6);                                     
             RETURN;                                                 
        ENDIF;                                                       
                                                                     
        IF %SCAN(X'7C' : CONMAIL)= 1 OR                              
           %SCAN(X'7C' : CONMAIL)= %LEN(%TRIM(CONMAIL));             
            *IN30 = *ON;                                     
            ERRMSG = ERRARR(6);                                 
            RETURN;                                             
        ENDIF;                                                  
                                                                
        IF %SCAN(X'4B' : CONMAIL) = 0 OR                        
           %SCAN(X'4B' : CONMAIL : %SCAN(X'7C' : CONMAIL)) = 0; 
           *IN30 = *ON;                                         
            ERRMSG = ERRARR(6);                                 
            RETURN;                                             
        ENDIF;                                                  
                                                                
        IF %SCAN(X'4B' : CONMAIL) = 0 OR                        
           %SCAN(X'4B' : CONMAIL) = %LEN(%TRIM(CONMAIL));       
           *IN30 = *ON;                                         
           ERRMSG = ERRARR(6);                                  
           RETURN;                                              
        ENDIF;                                                  
                                                                
        IF %SCAN(X'4B4B' : CONMAIL) > 0;                        
             *IN30 = *ON;                                                                                                                 
             ERRMSG = ERRARR(6);                                          
             RETURN;                                                      
        ENDIF;                                                            
       ENDIF;                                                             
                                                                          
     IF %CHECK(X'C1C2C3C4C5C6C7C8C9D1D2D3D4D5D6D7D8D9E2E3E4E5E6E7E8E9'+   
               X'818283848586878889919293949596979899A2A3A4A5A6A7A8A9'+   
               X'F0F1F2F3F4F5F6F7F8F9' +                                  
               X'7C' +                                                    
               X'4B' +                                                    
               X'6D' +                                                    
               X'60': CONMAIL) = 0;                                       
              *IN30 = *ON;                                                
              ERRMSG = ERRARR(6);                                         
              RETURN;                                                     
     ENDIF;                                                               
                                                                          
       IF CONFEC <> *ZEROS;                                               
        TEST(DE) *ISO CONFEC;                                             
         IF (%ERROR);   
          *IN31 = *ON;                                               
          ERRMSG = ERRARR(7);                                        
         ENDIF;                                                      
       ENDIF;                                                        
                                                                     
       IF CONHRA = *ZEROS;                                           
        IF %DEC(%SUBST(%CHAR(CONHRA): 1:2): 2 : 0) > 24;             
        *IN32 = *ON;                                                 
         ERRMSG = ERRARR(8);                                         
         RETURN;                                                     
        ENDIF;                                                       
                                                                     
        IF %DEC(%SUBST(%CHAR(CONHRA): 3:2): 2 : 0) > 60;             
         *IN32 = *ON;                                                
         ERRMSG = ERRARR(8);                                         
         RETURN;                                                     
        ENDIF;                                                       
       ENDIF;                    
       IF CONUSE = *BLANKS;                                            
        *IN33 = *ON;                                                   
        ERRMSG = ERRARR(9);                                            
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
     Chain(n) CONCOD MAECON;                                           
     DOW *IN12 = *OFF;                                                 
      EXFMT CRTCON;                                                    
     ENDDO;                                                            
     RETURN;                                                           
    END-PROC;                                                          
**                              
CODIGO DE CONTACTO EN BLANCO    
NOMBRE DE CONTACTO EN BLANCO    
APELLIDO DE CONTACTO EN BLANCO  
TELEFONO DE CONTACTO EN BLANCO  
CELULAR DE CONTACTO EN BLANCO   
DIRECCION DE EMAIL NO VALIDA    
FECHA DE CREACION NO VALIDA     
HORA DE CREACION NO VALIDA      
USUARIO DE CREACION EN BLANCO                                                  
                                                                                                                                                        
                                                                     
                                                                                                                       
                                                                                  
                                  