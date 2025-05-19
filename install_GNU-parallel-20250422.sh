#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p short


# Setting up the environment
source env_GNU-parallel-20250422.sh

# Creating the src directory for the installed application
mkdir -p $SOFTWARE_DIRECTORY/src

# Installing $SOFTWARE_NAME/$SOFTWARE_VERSION
cd $SOFTWARE_DIRECTORY/src
wget https://ftpmirror.gnu.org/parallel/parallel-latest.tar.bz2
tar -xvjf parallel-latest.tar.bz2
cd parallel-20250422
./configure --prefix=$SOFTWARE_DIRECTORY
make
make install

# Test
parallel

# Creating modulefile
touch $SOFTWARE_VERSION
echo "#%Module" >> $SOFTWARE_VERSION
echo "module-whatis	 \"Loads $SOFTWARE_NAME/$SOFTWARE_VERSION module." >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "This module was build on $(date)" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "GNU parallel is a shell tool for executing jobs in parallel using one or more computers. For more details, see https://www.gnu.org/software/parallel/" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "The script used to build this module can be found here: $GITHUB_URL" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "To load the module, type:" >> $SOFTWARE_VERSION
echo "module load $SOFTWARE_NAME/$SOFTWARE_VERSION" >> $SOFTWARE_VERSION
echo "\"" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "conflict	 $SOFTWARE_NAME" >> $SOFTWARE_VERSION
echo "setenv     CUDA_HOME $SOFTWARE_DIRECTORY" >> $SOFTWARE_VERSION
echo "setenv     CUDA_PATH $SOFTWARE_DIRECTORY" >> $SOFTWARE_VERSION
echo "setenv     CUDA_VERSION $SOFTWARE_VERSION" >> $SOFTWARE_VERSION
echo "prepend-path	 PATH $SOFTWARE_DIRECTORY/bin" >> $SOFTWARE_VERSION
echo "prepend-path	 MANPATH $SOFTWARE_DIRECTORY/doc/man" >> $SOFTWARE_VERSION
echo "prepend-path	 LD_LIBRARY_PATH $SOFTWARE_DIRECTORY/lib64" >> $SOFTWARE_VERSION
echo "prepend-path	 CPATH $SOFTWARE_DIRECTORY/include" >> $SOFTWARE_VERSION
echo "prepend-path	 LIBRARY_PATH $SOFTWARE_DIRECTORY/lib64" >> $SOFTWARE_VERSION

# Moving modulefile
mkdir -p $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME
cp $SOFTWARE_VERSION $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME/$SOFTWARE_VERSION
