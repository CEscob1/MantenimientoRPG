   CTL-OPT DFTACTGRP(*NO) CCSID(*char:273);                           
***-------------------------------------------------------------------
***   AUTOR: CARLOS MAURICIO ESCOBAR AGUILAR                          
***   DESCRIPCION: LABORATORIO DE MANTENIMIENTO DE CLIENTES CON SDA   
***-------------------------------------------------------------------
     DCL-F   MAEEMP USAGE(*OUTPUT:*UPDATE:*DELETE) KEYED;             
     DCL-F   MAEGRO USAGE(*INPUT) KEYED;                              
     DCL-F   AGE0001FM WORKSTN SFILE(SFL001:RRN);                     
***-------------------------------------------------------------------
***     PROGRAMA IMPRESION REPORTE MAESTRO DE EMPRESAS                
***-------------------------------------------------------------------
     DCL-PR  REP0001 EXTPGM('REP0001');                               
     END-PR;                                                          
***-------------------------------------------------------------------
***     PROGRAMA AYUDA GIRO DE EMPRESAS                               
***-------------------------------------------------------------------
     DCL-PR  HLP0001 EXTPGM('HLP0001');                                
      WGROCOD PACKED(5:0);                                             
      WGRODES CHAR(40);                                                
     END-PR;                                                           
***--------------------------------------------------------------------
***     PROGRAMA AYUDA CONTACTO DE EMPRESAS                            
***--------------------------------------------------------------------
     DCL-PR  HLP0002 EXTPGM('HLP0002');                                
      WCONCOD PACKED(5:0);                                             
      WCONNOM CHAR(50);                                                
     END-PR;                                                           
***--------------------------------------------------------------------
     DCL-S   ERRARR     CHAR(70) DIM(8) CTDATA PERRCD(1);              
     DCL-S   RRN       PACKED(5:0);                                    
     DCL-S   wEMPNOM    CHAR(40);                                      
     DCL-S   wGRODES    CHAR(40);                                      
     DCL-S   WCONCOD   PACKED(5:0);         
     DCL-S   WCONNOM    CHAR(50);                                      
     DCL-S   wEMPGRO   PACKED(5:0);                                    
     DCL-S   wEMPGDT    CHAR(50);                                      
     DCL-S   wGROCOD   PACKED(5:0);                                    
     DCL-S   wEMPCID   PACKED(5:0);                                    
     DCL-S   wEMPDR1    CHAR(40);                                      
     DCL-S   wEMPDR2    CHAR(40);                                      
     DCL-S   wEMPEST    CHAR(30);                                      
     DCL-S   wEMPPAI    CHAR(20);                                      
     DCL-S   wEMPTEL   PACKED(10:0);                                   
     DCL-S   wEMPCEL   PACKED(10:0);                                   
     DCL-S   wEMPMAIL   CHAR(100);                                     
     DCL-S   wEMPRPT    CHAR(50);                                      
     DCL-S   wEMPFEC   PACKED(8:0);                                    
     DCL-S   wEMPRFC     Char(12);                                     
***--------------------------------------------------------------------
     DOW *IN03 = *OFF;     
      SR_DATOS();                                                      
      WRITE CRTCMD;                                                    
      EXFMT CTL001;                                                    
      Select;                                                          
       When *in03;                                                     
       When *in06;                                                     
         PR_ALTA();                                                    
       WHEN *IN09;                                                     
         REP0001();                                                    
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
       WRITE CTL001;                                                   
       CLEAR OP;                                                       
       *IN93 = *OFF;                                                   
       *IN92 = *OFF;                                                   
       RRN = 0;                                                        
       *in12=*Off;                                                     
  // Llena el Subfile.                                                 
       SETLL *START MAEEMP;                                            
       READ(N) MAEEMP;                                                 
        DOW NOT %EOF(MAEEMP);                                          
         RRN +=1;                                                      
         WRITE SFL001;                                                 
         READ MAEEMP;                                                  
        ENDDO;          
 *// Evalua el despliegue del Subfile.                                 
        IF RRN = 0;                                                    
           *IN92 = *ON;                                                
        ENDIF;                                                         
     END-PROC;                                                         
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO ADICIONA                                      
**---------------------------------------------------------------------
    DCL-PROC PR_ALTA;                                                  
       clear crtalt;                                                   
       DOW *IN12 = *OFF;                                               
        EXFMT CRTALT;                                                  
           IF *IN04;                                                   
            IF FIELD = 'EMPCID';                                       
             HLP0002(WCONCOD:WCONNOM);                                 
             EMPCID = WCONCOD;                                         
             EMPRPT = WCONNOM;   
            ELSEIF FIELD = 'EMPGRO';                                   
             HLP0001(WGROCOD:WGRODES);                                 
             EMPGRO = WGROCOD;                                         
             EMPGDT = WGRODES;                                         
            *IN04 = *OFF;                                              
            ENDIF;                                                     
           ENDIF;                                                      
                                                                       
           IF FIELD = 'WCONCOD';                                       
            HLP0002(WCONCOD:WCONNOM);                                  
            EMPCID = WCONCOD;                                          
            EMPRPT = WCONNOM;                                          
           ENDIF;                                                      
                                                                       
          IF *IN01;                                                    
           PR_VALIDA();                                                
           IF ERRMSG = *BLANKS;            
            Chain(n) empcod MAEEMP;                                    
            If Not %found;                                             
             WRITE RMAEEMP;                                            
             LEAVE;                                                    
            Endif;                                                     
           ENDIF;                                                      
          ENDIF;                                                       
       ENDDO;                                                          
    END-PROC;                                                          
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO MODIFICA                                      
**---------------------------------------------------------------------
    DCL-PROC PR_MODIFICA;                                              
      Chain(n) empcod MAEEMP;                                          
      COMP01 = %SUBST(EMPMAIL: 1 : 50);                                
      COMP02 = %SUBST(EMPMAIL:51);                                     
      DOW *IN12 = *OFF;        
       EXFMT CRTMOD;                                                   
           IF *IN04;                                                   
            IF FIELD = 'EMPCID';                                       
             HLP0002(WCONCOD:WCONNOM);                                 
             EMPCID = WCONCOD;                                         
             EMPRPT = WCONNOM;                                         
            ELSEIF FIELD = 'EMPGRO';                                   
             HLP0001(WGROCOD:WGRODES);                                 
             EMPGRO = WGROCOD;                                         
             EMPGDT = WGRODES;                                         
            *IN04 = *OFF;                                              
            ENDIF;                                                     
           ENDIF;                                                      
                                                                       
           IF *IN01;                                                   
            PR_VALIDA();                                               
            IF ERRMSG = *BLANKS;     
             wEMPNOM=EMPNOM;                                          
             wEMPGRO=EMPGRO;                                          
             wEMPGDT=EMPGDT;                                          
             wEMPDR1=EMPDR1;                                          
             wEMPDR2=EMPDR2;                                          
             wEMPEST=EMPEST;                                          
             wEMPPAI=EMPPAI;                                          
             wEMPTEL=EMPTEL;                                          
             wEMPCEL=EMPCEL;                                          
             wEMPMAIL=EMPMAIL;                                        
             wEMPCID=EMPCID;                                          
             wEMPRPT=EMPRPT;                                          
             wEMPFEC=EMPFEC;                                          
             wEMPRFC=EMPRFC;                                          
             Chain empcod MAEEMP;                                     
             If %found;                                               
              EMPNOM=wEMPNOM;          
              EMPGRO=wEMPGRO;                                          
              EMPGDT=wEMPGDT;                                          
              EMPDR1=wEMPDR1;                                          
              EMPDR2=wEMPDR2;                                          
              EMPEST=wEMPEST;                                          
              EMPPAI=wEMPPAI;                                          
              EMPTEL=wEMPTEL;                                          
              EMPCEL=wEMPCEL;                                          
              EMPMAIL=wEMPMAIL;                                        
              EMPCID=wEMPCID;                                          
              EMPRPT=wEMPRPT;                                          
              EMPFEC=wEMPFEC;                                          
              EMPRFC=wEMPRFC;                                          
              UPDATE RMAEEMP;                                          
              LEAVE;                                                   
             ENDIF;                                                    
            Endif;    
           ENDIF;                                                      
      ENDDO;                                                           
    END-PROC;                                                          
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO ELIMINA                                       
**---------------------------------------------------------------------
    DCL-PROC PR_ELIMINA;                                               
     Chain(n) empcod MAEEMP;                                           
     DOW *IN12 = *OFF;                                                 
       EXFMT CRTDEL;                                                   
        IF *IN11;                                                      
         Chain empcod MAEEMP;                                          
          If %found;                                                   
           DELETE RMAEEMP;                                             
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
                                                                       
       *IN25 = *OFF;                                                   
       *IN26 = *OFF;                                                   
       *IN27 = *OFF;                                                   
       *IN28 = *OFF;                                                   
       *IN29 = *OFF;                                                   
       *IN30 = *OFF;                                                   
       *IN31 = *OFF;                                                   
       *IN32 = *OFF;                                                   
       *IN33 = *OFF;    
       *IN34 = *OFF;                                                  
       *IN35 = *OFF;                                                  
       *IN36 = *OFF;                                                  
       *IN37 = *OFF;                                                  
       ERRMSG = *BLANKS;                                              
                                                                      
       IF EMPCOD = *ZEROS;                                            
        *IN25 = *ON;                                                  
        ERRMSG = ERRARR(2);                                           
       ENDIF;                                                         
                                                                      
       IF EMPNOM = *BLANKS;                                           
        *IN26 = *ON;                                                  
        ERRMSG = ERRARR(1);                                           
       ENDIF;                                                         
                                                                      
       IF %LEN(%TRIM(EMPRFC)) <> 12;       
        *IN27 = *ON;                                                   
        ERRMSG = ERRARR(3);                                            
       ENDIF;                                                          
                                                                       
       IF EMPGRO = *ZEROS;                                             
        *IN28 = *ON;                                                   
        ERRMSG = ERRARR(4);                                            
        RETURN;                                                        
       ENDIF;                                                          
                                                                       
       IF EMPDR1 = *BLANKS;                                            
        *IN29 = *ON;                                                   
        ERRMSG = ERRARR(1);                                            
       ENDIF;                                                          
                                                                       
       IF  EMPDR2 = *BLANKS;                                           
        *IN30 = *ON;        
        ERRMSG = ERRARR(1);                                            
       ENDIF;                                                          
                                                                       
       IF EMPEST = *BLANKS;                                            
        *IN31 = *ON;                                                   
        ERRMSG = ERRARR(1);                                            
       ENDIF;                                                          
                                                                       
       IF EMPPAI = *BLANKS;                                            
        *IN32 = *ON;                                                   
        ERRMSG = ERRARR(1);                                            
       ENDIF;                                                          
                                                                       
       IF EMPTEL = *ZEROS;                                             
        *IN33 = *ON;                                                   
        ERRMSG = ERRARR(5);                                            
       ENDIF;     
                                                                       
       IF EMPCEL = *ZEROS;                                             
        *IN34 = *ON;                                                   
        ERRMSG = ERRARR(6);                                            
       ENDIF;                                                          
                                                                       
       IF COMP01 <> *BLANKS OR COMP02 <> *BLANKS;                      
        EMPMAIL = %TRIM(COMP01) + %TRIM(COMP02);                       
                                                                       
        IF %SCAN(X'40' :%SUBST(EMPMAIL: 1: %LEN(%TRIM(EMPMAIL))))> 0;  
             *IN35 = *ON;                                              
             ERRMSG = ERRARR(8);                                       
             RETURN;                                                   
        ENDIF;                                                         
                                                                       
        IF %SCAN(X'7C' : EMPMAIL) = 0 OR                               
            %SCAN(X'7C' : EMPMAIL : %SCAN(X'7C' : EMPMAIL) + 1) > 0;  
             *IN35 = *ON;                                              
             ERRMSG = ERRARR(8);                                       
             RETURN;                                                   
        ENDIF;                                                         
                                                                       
        IF %SCAN(X'7C' : EMPMAIL)= 1 OR                                
           %SCAN(X'7C' : EMPMAIL)= %LEN(%TRIM(EMPMAIL));               
            *IN35 = *ON;                                               
            ERRMSG = ERRARR(8);                                        
            RETURN;                                                    
        ENDIF;                                                         
                                                                       
        IF %SCAN(X'4B' : EMPMAIL) = 0 OR                               
           %SCAN(X'4B' : EMPMAIL : %SCAN(X'7C' : EMPMAIL)) = 0;        
           *IN35 = *ON;                                                
            ERRMSG = ERRARR(8);                                        
            RETURN;                 
        ENDIF;                                                         
                                                                       
        IF %SCAN(X'4B' : EMPMAIL) = 0 OR                               
           %SCAN(X'4B' : EMPMAIL) = %LEN(%TRIM(EMPMAIL));              
           *IN35 = *ON;                                                
           ERRMSG = ERRARR(8);                                         
           RETURN;                                                     
        ENDIF;                                                         
                                                                       
        IF %SCAN(X'4B4B' : EMPMAIL) > 0;                               
             *IN35 = *ON;                                              
             ERRMSG = ERRARR(8);                                       
             RETURN;                                                   
        ENDIF;                                                         
       ENDIF;                                                          
                                                                       
     IF %CHECK(X'C1C2C3C4C5C6C7C8C9D1D2D3D4D5D6D7D8D9E2E3E4E5E6E7E8E9'+   
               X'818283848586878889919293949596979899A2A3A4A5A6A7A8A9'+
               X'F0F1F2F3F4F5F6F7F8F9' +                               
               X'7C' +                                                 
               X'4B' +                                                 
               X'6D' +                                                 
               X'60': EMPMAIL) = 0;                                    
              *IN35 = *ON;                                             
              ERRMSG = ERRARR(8);                                      
              RETURN;                                                  
     ENDIF;                                                            
                                                                       
       IF WCONCOD = *ZEROS;                                            
        *IN36 = *ON;                                                   
        ERRMSG = ERRARR(1);                                            
       ENDIF;                                                          
                                                                       
       IF EMPFEC <> *ZEROS;   
        TEST(DE) *ISO EMPFEC;                                          
         IF (%ERROR);                                                  
        *IN37 = *ON;                                                   
          ERRMSG = ERRARR(7);                                          
         ENDIF;                                                        
       ENDIF;                                                          
                                                                       
     RETURN;                                                           
    END-PROC;                                                          
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO OPCIONES DE USUARIO                           
**---------------------------------------------------------------------
  DCL-PROC PR_CMD;                                                     
   RRN=1;                                                              
   Chain RRN SFL001;                                                   
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
    Chain RRN SFL001;                                                  
    Enddo;                                                             
  END-PROC;                                                            
**---------------------------------------------------------------------
** EJECUTA PROCEDIMIENTO CONSULTA                                      
**---------------------------------------------------------------------
    DCL-PROC PR_CONSULTA;                                              
     Chain(n) EMPCOD MAEEMP;                                           
     COMP01 = %SUBST(EMPMAIL: 1 : 50);       
      COMP02 = %SUBST(EMPMAIL:51);                                      
      DOW *IN12 = *OFF;                                                 
       EXFMT CRTCON;                                                    
      ENDDO;                                                            
      RETURN;                                                           
     END-PROC;                                                          
**                                                            
CAMPO EN BLANCO, POR FAVOR LLENARLO                           
CODIGODE EMPRESA NO CUMPLE CON SU LONGITUD DE 5 CARACTERES    
NUMERO RFC NO CUMPLE CON SU LONGITUD DE 12 CARACTERES         
NUMERO DE GIRO NO CUMPLE CON SU LONGITUD DE 5 CARACTERES      
NUMERO DE TELEFONO NO CUMPLE CON SU LONGITUD DE 10 CARACTERES 
NUMERO DE CELULAR NO CUMPLE CON SU LONGITUD DE 10 CARACTERES  
FECHA NO VALIDA                                               
DIRECCION DE CORREO NO VALIDA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           