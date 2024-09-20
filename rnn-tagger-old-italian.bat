SET PARENTDIR=%~dp0..

SET BIN=%PARENTDIR%\bin
SET SCRIPTS=%PARENTDIR%\scripts
SET LIB=%PARENTDIR%\lib
SET PyRNN=%PARENTDIR%\PyRNN
SET PyNMT=%PARENTDIR%\PyNMT
SET TMP=%TEMP%\rnn-tagger%RANDOM%
SET LANGUAGE=old-italian

SET TOKENIZER=perl %SCRIPTS%\tokenize.pl
SET ABBR_LIST=%LIB%\Tokenizer\%LANGUAGE%-abbreviations
SET TAGGER=python %PyRNN%\rnn-annotate.py
SET RNNPAR=%LIB%\PyRNN\%LANGUAGE%
SET REFORMAT=perl %SCRIPTS%\reformat.pl
SET LEMMATIZER=python %PyNMT%\nmt-translate.py
SET NMTPAR=%LIB%\PyNMT\%LANGUAGE%

pip show torch >nul 2>&1
if %errorlevel% neq 0 (
    pip install torch
)

%TOKENIZER% -I -a %ABBR_LIST% %1 > %TMP%.tok

%TAGGER% %RNNPAR% %TMP%.tok > %TMP%.tagged

%REFORMAT% %TMP%.tagged > %TMP%.reformatted

%LEMMATIZER% --print_source %NMTPAR% %TMP%.reformatted > %TMP%.lemmas

%SCRIPTS%\lemma-lookup.pl %TMP%.lemmas %TMP%.tagged 

del %TMP%.tok  %TMP%.tagged  %TMP%.reformatted %TMP%.lemmas