--- src/zm_logger.cpp.orig	2016-09-18 12:03:06 UTC
+++ src/zm_logger.cpp
@@ -516,8 +516,9 @@ void Logger::logPrint( bool hex, const c
         va_list         argPtr;
         struct timeval  timeVal;
 
-        const char * const file = basename(filepath);
-        
+	char *filecopy = strdup(filepath);
+	const char * const file = basename(filecopy);       
+ 
         if ( level < PANIC || level > DEBUG9 )
             Panic( "Invalid logger level %d", level );
 
@@ -636,6 +637,8 @@ void Logger::logPrint( bool hex, const c
                 abort();
             exit( -1 );
         }
+	
+	free(filecopy);
     }
 }
 
