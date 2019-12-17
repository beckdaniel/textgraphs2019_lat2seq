#!/bin/sh

# Edit this line to point to the location of the Fisher/Callhome corpus
CORPUS=/lt/data/fisher_ch_spa-eng/data/corpus

# Edit this line to point to the location of your Moses tokenizer
MOSES_TOK=/home/dbeck1/mosesdecoder/scripts/tokenizer

#######################

FISHER=./data/fisher
mkdir -p $FISHER

SRC='es'
TGT='en'

for SET in 'train' 'dev' 'dev2' 'test';
do
    # Process raw data
    # Start with the gold transcriptions

    mkdir ${FISHER}/${SET}
    
    cat ${CORPUS}/ldc/fisher_${SET}.${SRC} | \
	${MOSES_TOK}/tokenizer.perl -l ${SRC} | \
	${MOSES_TOK}/lowercase.perl -l ${SRC} \
		    > ${FISHER}/${SET}/${SET}.gold.tok.lc.${SRC}
    
    if [ ${SET} = 'train' ]; then
	cat ${CORPUS}/ldc/fisher_${SET}.${TGT} | \
	    ${MOSES_TOK}/tokenizer.perl -l ${TGT} | \
	    ${MOSES_TOK}/lowercase.perl -l ${TGT} \
			> ${FISHER}/${SET}/${SET}.tok.lc.${TGT}
    # dev, dev2 and test have multiple references for English
    else	
	for I in 0 1 2 3;
	do
	    cat ${CORPUS}/ldc/fisher_${SET}.${TGT}.${I} | \
		${MOSES_TOK}/tokenizer.perl -l ${TGT} | \
		${MOSES_TOK}/lowercase.perl -l ${TGT} \
			    > ${FISHER}/${SET}/${SET}${I}.tok.lc.${TGT}
	done
    fi
    
    # Process asr and oracle, removing blank lines.

    if [ $SET = 'train' ]; then
	paste ${CORPUS}/asr/fisher_${SET}.${SRC} \
	      ${CORPUS}/oracle/fisher_${SET}.${SRC} \
	      ${FISHER}/${SET}/${SET}.gold.tok.lc.${SRC} \
	      ${FISHER}/${SET}/${SET}.tok.lc.${TGT} | \
	    grep -v -P '^\t' | \
	    grep -v -P '\t\t' \
		 > ${FISHER}/${SET}/${SET}.alldata
	
	cut -f1 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.asr.filt.${SRC}
	
	cut -f2 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.oracle.filt.${SRC}
	
	cut -f3 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.gold.tok.lc.filt.${SRC}

	cut -f4 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.tok.lc.filt.${TGT}
    
    else
	paste ${CORPUS}/asr/fisher_${SET}.${SRC} \
	      ${CORPUS}/oracle/fisher_${SET}.${SRC} \
	      ${FISHER}/${SET}/${SET}.gold.tok.lc.${SRC} \
	      ${FISHER}/${SET}/${SET}0.tok.lc.${TGT} \
	      ${FISHER}/${SET}/${SET}1.tok.lc.${TGT} \
	      ${FISHER}/${SET}/${SET}2.tok.lc.${TGT} \
	      ${FISHER}/${SET}/${SET}3.tok.lc.${TGT} | \
	    grep -v -P '^\t' | \
	    grep -v -P '\t\t' \
		 > ${FISHER}/${SET}/${SET}.alldata
	
	cut -f1 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.asr.filt.${SRC}

	cut -f2 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.oracle.filt.${SRC}

	cut -f3 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}.gold.tok.lc.filt.${SRC}
    
	cut -f4 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}0.tok.lc.filt.${TGT}

	cut -f5 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}1.tok.lc.filt.${TGT}

	cut -f6 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}2.tok.lc.filt.${TGT}

	cut -f7 ${FISHER}/${SET}/${SET}.alldata \
	    > ${FISHER}/${SET}/${SET}3.tok.lc.filt.${TGT}
    fi
done
