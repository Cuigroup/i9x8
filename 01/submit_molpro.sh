#!/bin/bash
IN=$1

# get the filename without the extension
JOB=${IN%.*}

SUBMIT=qsub.tmp
PWD=`pwd`

# Numbers of prcessors - specify here!
# This is the only user variable in this script.
PPN=12


#####################################################################
############## DON'T CHANGE ANYTHING BELOW THIS LINE ################


# Will automatically allocate 4GB memory per processor (max on sunray)

cat > $SUBMIT <<!EOF
#!/bin/bash
#PBS -N $JOB
#PBS -V
#PBS -l nodes=1:ppn=$PPN
#PBS -l walltime=24:00:00
#PBS -l mem=32916344kb
#PBS -e /home/andersx/pbs/logs
#PBS -o /home/andersx/pbs/logs


export MOLPRO=/home/andersx/molpro/molprop_2012_1_Linux_x86_64_i8/bin/molpro

cd $PWD
export OPTIONS="-m 350m -n $PPN -d /scratch/\$PBS_JOBID -I /scratch/\$PBS_JOBID -W /scratch/\$PBS_JOBID --no-xml-output"
\$MOLPRO \$OPTIONS $JOB.inp

rm -rf /scratch/\$PBS_JOBID

!EOF

qsub $SUBMIT
rm $SUBMIT

