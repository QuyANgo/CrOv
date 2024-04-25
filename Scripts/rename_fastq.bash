#!/bin/bash

# rename fastq files

cd /home/localadmin/Documents/RESEARCH/SBobisse/fastq

rename 's/GEXA/.GEX_A/g' *
rename 's/GEXB/.GEX_B/g' *
rename 's/GEXC/.GEX_C/g' *
rename 's/GEXD/.GEX_D/g' *

rename 's/VDJA/.VDJ_A/g' *
rename 's/VDJB/.VDJ_B/g' *
rename 's/VDJC/.VDJ_C/g' *
rename 's/VDJD/.VDJ_D/g' *

rename 's/VA/.VDJ_A/g' *
rename 's/VB/.VDJ_B/g' *
rename 's/VC/.VDJ_C/g' *
rename 's/VD/.VDJ_D/g' *

rename 's/0SM8T0/CrCm6/g' *
rename 's/Crcp/CrCp/g' *
rename 's/12vVDJ/OvCa1682.VDJ/g' *
rename 's/12GEX/OvCa1682.GEX/g' *

rename 's/..VDJ/.VDJ/g' *
rename 's/CrCp.VDJ/CrCp7.VDJ/g' *
rename 's/OvCa180.VDJ/OvCa1809.VDJ/g' *
rename 's/VDJ_DJ/VDJ/g' *
rename 's/1637./OvCa1637./g' *
rename 's/12./OvCa1682./g' *

rename 's/wOvCa1682.Ws004akN/w12RWs004akN/g' *
rename 's/5qPU.VDJ_AeNXkSE/5qPUVAeNXkSE/g' *
