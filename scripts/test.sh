#!/bin/bash -e

bash ./clean.sh > test.log
N=`find ../tests -name "*.c" | wc -l`
PASS=0
for fn in `find ../tests -name "*.c"`; do
    CTOEO=$(eval " realpath $1")
    FILE=$(eval " realpath ${fn}")
    NAME="${fn##*/}"
    {
    mkdir ${FILE%%.c}
    unzip env.zip -d ${FILE%%.c} >> test.log
    gcc ${FILE} -o ${FILE%%.c}/${NAME%%.c}.out -w
    eval " ${FILE%%.c}/${NAME%%.c}.out > ${FILE%%.c}/${NAME%%.c}.res_c"
    eval " ${CTOEO} ${FILE} -- -d ${FILE%%.c}/env/eo/ > ${FILE%%.c}/${NAME%%.c}.details 2>${FILE%%.c}/${NAME%%.c}.log"
    while read -r line; do
        if [[ "$line" == "var"*"> g_"* ]]; then
            echo "    stdout (g.${line#*> }.toString)" >>  ${FILE%%.c}/env/eo/app.eo
            echo "    stdout \"\n\""  >>  ${FILE%%.c}/env/eo/app.eo
        fi
    done < "./glob.global"
    mvn -f ${FILE%%.c}/env/ clean compile >> test.log 2>> ${FILE%%.c}/${NAME%%.c}.log
    java -cp ${FILE%%.c}/env/target/classes:${FILE%%.c}/env/target/eo-runtime.jar org.eolang.phi.Main c2eo.app > ${FILE%%.c}/${NAME%%.c}.res_eo 2>${FILE%%.c}/${NAME%%.c}.log
    diff -a ${FILE%%.c}/${NAME%%.c}.res_c ${FILE%%.c}/${NAME%%.c}.res_eo > ${FILE%%.c}/${NAME%%.c}.diff
    DIFF=${FILE%%.c}/${NAME%%.c}.diff
    TEST=$(eval " realpath ${DIFF}")
    if [ -s $DIFF ]; then
        # The file is not-empty.
        printf "\033[0;31m[-]\t${NAME%%.c}\n\033[0;37m"
        cat ${FILE%%.c}/${NAME%%.c}.diff
    else
        # The file is empty.
        printf "\033[0;32m[+]\t${NAME%%.c}\n"
        ((PASS+=1))
    fi
    } || {
      printf "\033[0;31m[X]\t${NAME%%.c}\n"
    }
done
printf "\033[0;32m$PASS/$N Tests passed.\033[0;37m"