To begin using DMAT, you need to follow some simple steps. In most cases, if something out of the ordinary happens, the installer will guide you along.

1) Check that you have MATLAB version 2006a or better, and have it and the Optimization Toolbox installed correctly.

2) Extract the ZIP archive to the folder "\toolbox" that should be in your MATLAB install path. A new folder called "\dmatoolbox" should appear (if you do not know your MATLAB install path, MATLAB will tell you what it is if you type ''matlabroot'' at the command line).

3) At the MATLAB command line, type the following: run('../toolbox/dmatoolbox/installer.m')
(If you installed to another directory, change this command in the obvious way.) Follow any isntructions that might appear. You will be asked to read and approve an End User License Agreement. Please read it carefully.

These steps should have succesfully installed the DMA Toolbox. Get started using it by typing ''dmatdoc'' at the command line, which will display the HTML documentation files in the MATLAB help browser (or you can execute ''dmatdoc('web','-browser')'', which will cause the documentation to be displayed in your default browser).

A short list of known or expected issues:
- The  qpplot  function is agonizingly slow, especially with a large number of conditions. This function also renders the quantile probability plot in the graphical output viewer and may block it for several minutes... each time you view it.
- For ill-behaved data or poorly specified designs with many parameters, the estimation algorithm may not find a minimum (and thus return non-real values for standard errors of estimation) or take a very long time to converge (sometimes hours). If you notice this, it is usually best to abort and try another model formulation.

Getting in touch with the DMAT community:
To subscribe to the DMAT mailing list, simply send an e-mail with only the words "subscribe dmatoolbox" (in the mail body, without quotation marks) to listserv@listserv.cc.kuleuven.be. You will receive a confirmation mail shortly afterward.