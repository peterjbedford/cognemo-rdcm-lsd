# cognemo-rdcm-lsd

RDCM, CLASSICAL STATS, ML:

Ensure that your Matlab path and 'current folder' reflect the instructions below (see *FOLDER & PATH* below)
The pipeline is broken up into two parts. PipelineP1 performs the rDCM procedure with BOLD data as input and effective connectivity matrices as output. Pipline P2 performs the analysis on the connectivity parameter values.

*FOLDER & PATH*

Should have in your Matlab path:

For PipelineP1:

These are necessary for rDCM
- TAPAS\tapas-master\rDCM\code
- TAPAS\tapas-master\rDCM\misc

Should have in your 'current folder'

'Tools' folder
- contains the scripts hosted in this repository; PipelineP1.m will add these to your path

'data.mat'
- contains the BOLD data.

'Ast.mat'
- contains a structural connectivity-based 'prior' matrix which is used in the 'structural prior' rDCM method ('ECst'). This is optional and must be supplied for new analyses (since the atlas used and regions included/excluded are unlikely to be exactly the same for more than one experiment)

For PipelineP2:

'Tools' folder
- contains the scripts hosted in this repository; PipelineP1.m will add these to your path

'Output_P1'
- this would have been created by PipelineP1. It contains the output therefrom.

'vital.mat'
- this contains physiological parameter baseline measurements that can be used to 'regress out' effects not accountable by connectivity alone. This is optional


Resources

Find below links to all the papers I relied on to become familiarized with rDCM, generative embedding, and ML classification.
Tools:

For rDCM implementation: TAPAS (MATLAB)

rDCM Papers:
- (Frässle et al. 2017) Regression DCM for fMRI (introduction)
- (Frässle et al. 2018) A generative model of whole brain effective connectivity (adding sparsity optimization)
- (Frässle et al. 2021) Regression dynamic causal modelling for resting state fMRI (adapting to resting state fMRI)
- (Frässle et al. 2022) Test-retest reliability of regression dynamic causal modeling (comparing fully-connected to sparsity-optimized EC networks)

Generative embedding:
- (Brodersen et al. 2011) Model-based feature construction for multivariate decoding (introduction)
- (Broderson et al. 2014) Dissecting psychiatric spectrum disorders by generative embedding (empirical proof-of-concept)
- (Frässle et al. 2020) Predicting individual trajectories of depression with generative embedding (MDD dataset with identical pipeline–by creators of rDCM)

Classification
- (Text: Christopher Bishop, 2006) Pattern Recognition and Machine Learning (good for understanding basic principles, validation methods, and some ML classification and regression types–random forest is NOT included however)
- (MATLAB Help Center) Treebagger - Random Forest generator 
