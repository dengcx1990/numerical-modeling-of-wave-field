        !COMPILER-GENERATED INTERFACE MODULE: Wed Mar 22 09:31:23 2017
        MODULE CREATE_FILE__genmod
          INTERFACE 
            SUBROUTINE CREATE_FILE(N_FILE,FILENAME,FILE_EXTENSION,      &
     &FILE_NAME,OUTPUT_FILENAME)
              INTEGER(KIND=4) :: N_FILE
              CHARACTER(*) :: FILENAME
              CHARACTER(*) :: FILE_EXTENSION
              CHARACTER(*) :: FILE_NAME(1:N_FILE)
              CHARACTER(*) :: OUTPUT_FILENAME
            END SUBROUTINE CREATE_FILE
          END INTERFACE 
        END MODULE CREATE_FILE__genmod
