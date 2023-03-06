%
% Supplementary material of the paper: 
% Automatic identification of lung opacities due to COVID-19 from chest X-Ray images. Focussing attention on the lungs
% Submitted to the journal "Diagnostics" 
% 
% This script has several functionalities 
% 
% 1. Resizes the bounding boxes of the SIIM-FISABIO-RSNA COVID-19 Detection data set according to the size of the cropped images
% 2. Creates a new image of the same size as the original with a black framework around the cropped image
% 3. Calculates the new bounding boxes for the new images processed (with the black framework around)
%
% This script does neither segment the lungs nor calculate the cropped images. 
% The original and cropped images are stored in their respective directories. Each original image must have a cropped version  
% This procedure can also be applied to the segmented images instead to the cropped ones. 
% 

clear all, close all
warning('off')

% If lflag equals 1, the script shows results for each image. If lFlag equals 0, there is no show. 
lFlag= 1; 

% If lCentrada equals 1, the new image is created with the cropped one centred. 
% If lCentrada equals 0, the cropped image is placed in its original position. 
lCentrada = 0; 

% sDirOrigenOriginal is the directory where the original images are placed
sDirOrigenOriginal='E:\siim-covid-19-cropped-segmented\train_512x512\';

% sDirOrigenCropped is the directory where the cropped images are placed 
sDirOrigenCropped='E:\siim-covid-19-cropped-segmented\Cropped\';

% sDirDestino contains the directory to store the new images after the processing procedure   
if lCentrada, sDirDestino='c:\temp\centered'; 
else sDirDestino='c:\temp\no-centered\'; end; 

% sTablaOrigen is the .csv file storing the Bounding boxes. This is provided by the authors of the data set.  
sTablaOrigen='E:\siim-covid-19-cropped-segmented\df_train_processed_meta_512x512.csv'; 

% These two variables contain the name of the .csv files with the new bounding boxes for the cropped and processed images respectively  
sTablaDestinoCropped='df_train_processed_meta_512x512_cropped.csv'; 
sTablaDestinoProcesado='df_train_processed_meta_512x512_procesado.csv'; 

% We load the bounding boxes of the original images  
try 
    tInfoOriginal=readtable( sTablaOrigen ); 
catch
    disp( 'Error while reading the .csv file containing the bounding boxes' );
end;   
tInfoCropped= tInfoOriginal; 

% We load the names of the files in the directory containing the original and cropped images 
eDirOriginal=dir( strcat( sDirOrigenOriginal , '*.png' ) );
eDirCropped=dir( strcat( sDirOrigenCropped , '*.png' ) );

eBoxOriginal=struct( 'xmin', 0, 'xmax', 0, 'ymin', 0, 'ymax', 0, 'width', 0, 'height', 0);
eBoxCropped=struct( 'xmin', 0, 'xmax', 0, 'ymin', 0, 'ymax', 0, 'width', 0, 'height', 0);
eBoxImagen=struct( 'xmin', 0, 'xmax', 0, 'ymin', 0, 'ymax', 0, 'width', 0, 'height', 0);
eBoxProcesada=struct( 'xmin', 0, 'xmax', 0, 'ymin', 0, 'ymax', 0, 'width', 0, 'height', 0);
eBoxCentrada=struct( 'xmin', 0, 'xmax', 0, 'ymin', 0, 'ymax', 0, 'width', 0, 'height', 0);

iContador = 0; 
% For each image in the data set  
for i=1:length(eDirOriginal)  
    sFicheroOriginal=strcat( eDirOriginal(i).folder, filesep, eDirOriginal(i).name );
    sFicheroCropped=strcat( eDirCropped(i).folder, filesep, eDirOriginal(i).name );
    sFicheroProcesado= strcat( sDirDestino, eDirOriginal(i).name ); 
    
    disp( strcat( 'Procesando: ', sFicheroOriginal ) );

    % We open and load the original and cropped images into memory  
    try
        mImageOriginal = im2gray( imread( sFicheroOriginal ) );
        mImageCropped = im2gray( imread( sFicheroCropped ) );
        mImageComp=mImageOriginal;
    catch
        disp( 'Error while opening the file' );
    end;

    % We calculate the shift between the original image and the cropped one by means of a cross correlation procedure  
    mCorr = normxcorr2( mImageCropped, mImageOriginal);
    [ssr,snd] = max(mCorr(:));
    [iY,iX] = ind2sub(size(mCorr),snd);
    %     surf(mCorr)
    %     shading flat

    iFilasImageOriginal = size(mImageOriginal,1); 
    iColumnasImageOriginal = size(mImageOriginal,2); 
    iFilasImageCropped = size(mImageCropped,1); 
    iColumnasImageCropped = size(mImageCropped,2); 

    eBoxImagen.xmin= iX-iColumnasImageCropped+1 ;  
    eBoxImagen.xmax= iX ;  
    eBoxImagen.ymin= iY-iFilasImageCropped+1 ;  
    eBoxImagen.ymax= iY ;  

    mImageProcesada=zeros( size( mImageOriginal ) ); 
    if lCentrada
        eBoxCentrada.xmin = floor( (iColumnasImageOriginal - iColumnasImageCropped )/2 ) +1;
        eBoxCentrada.ymin = floor( (iFilasImageOriginal - iFilasImageCropped )/2 ) +1;
        eBoxCentrada.xmax = eBoxCentrada.xmin + iColumnasImageCropped -1;
        eBoxCentrada.ymax = eBoxCentrada.ymin + iFilasImageCropped -1;
        mImageProcesada( eBoxCentrada.ymin:eBoxCentrada.ymax, eBoxCentrada.xmin:eBoxCentrada.xmax ) = mImageCropped ;
    else
        mImageProcesada( eBoxImagen.ymin:eBoxImagen.ymax, eBoxImagen.xmin:eBoxImagen.xmax ) = mImageCropped ;
    end; 

    mImageProcesada = uint16(65536 * mat2gray( mImageProcesada ));

    % We write a .png file with the new proccessed image 
    % The processed image is stored in the directory specfied by sDirDestino 
    try 
        imwrite(mImageProcesada, sFicheroProcesado, 'png' );
    catch
        disp( strcat( 'Error creating the file with the processed image: -', sFicheroProcesado) ); 
    end;

    vIdx = strcmp( strcat( cellstr( tInfoOriginal.id ), '.png' ), eDirOriginal(i).name );
    tDataOriginal = tInfoOriginal( vIdx, : );
    tDataCropped = tInfoOriginal( vIdx, : );
    tDataProcesada = tInfoOriginal( vIdx, : );

    if size( tDataOriginal, 1 ) == 0, disp( 'Imagen sin BBox' ), iContador = iContador +1; end; 

    for j=1:size( tDataOriginal, 1 ) % For all bounding boxes of each image  

        eBoxOriginal.xmin= tDataOriginal.xmin(j) ;  
        eBoxOriginal.xmax= tDataOriginal.xmax(j) ;  
        eBoxOriginal.ymin= tDataOriginal.ymin(j) ;  
        eBoxOriginal.ymax= tDataOriginal.ymax(j) ;  
        eBoxOriginal.width= tDataOriginal.xmax(j)-tDataOriginal.xmin(j);  
        eBoxOriginal.height= tDataOriginal.ymax(j)-tDataOriginal.ymin(j) ;  
        mImageOriginal = insertShape( mImageOriginal, 'rectangle', [eBoxOriginal.xmin, eBoxOriginal.ymin, eBoxOriginal.width, eBoxOriginal.height ], LineWidth=3, Color=["green"] );

        eBoxCropped.xmin= eBoxOriginal.xmin-eBoxImagen.xmin ;  
        eBoxCropped.xmax= eBoxOriginal.xmax-eBoxImagen.xmin ;  
        eBoxCropped.ymin= eBoxOriginal.ymin-eBoxImagen.ymin ;  
        eBoxCropped.ymax= eBoxOriginal.ymax-eBoxImagen.ymin ;  
        if eBoxCropped.xmin <= 0, eBoxCropped.xmin = 1; disp( 'BBox cropped in xmin' ); end; 
        if eBoxCropped.xmax > iColumnasImageCropped, eBoxCropped.xmax = iColumnasImageCropped; disp( 'BBox cropped in xmax' ); end; 
        if eBoxCropped.ymin <= 0, eBoxCropped.ymin = 1; disp( 'BBox cropped in ymin' ); end; 
        if eBoxCropped.ymax > iFilasImageCropped, eBoxCropped.ymax = iFilasImageCropped; disp( 'BBox cropped in ymax' ); end; 
        eBoxCropped.width= eBoxCropped.xmax-eBoxCropped.xmin;  
        eBoxCropped.height = eBoxCropped.ymax-eBoxCropped.ymin ;  
        mImageCropped = insertShape( mImageCropped, 'rectangle', [eBoxCropped.xmin, eBoxCropped.ymin, eBoxCropped.width, eBoxCropped.height ], LineWidth=3, Color=["red"] );
    
        if lCentrada
            eBoxProcesada.xmin = eBoxCropped.xmin + eBoxCentrada.xmin ;
            eBoxProcesada.xmax = eBoxCropped.xmax + eBoxCentrada.xmin ;
            eBoxProcesada.ymin = eBoxCropped.ymin + eBoxCentrada.ymin ;
            eBoxProcesada.ymax = eBoxCropped.ymax + eBoxCentrada.ymin ;
            eBoxProcesada.width = eBoxCropped.width ;
            eBoxProcesada.height = eBoxCropped.height;
        else
            eBoxProcesada.xmin = eBoxCropped.xmin + eBoxImagen.xmin ;
            eBoxProcesada.xmax = eBoxCropped.xmax + eBoxImagen.xmin ;
            eBoxProcesada.ymin = eBoxCropped.ymin + eBoxImagen.ymin ;
            eBoxProcesada.ymax = eBoxCropped.ymax + eBoxImagen.ymin ;
            eBoxProcesada.width = eBoxCropped.width ;
            eBoxProcesada.height = eBoxCropped.height;
        end;
        mImageProcesada = insertShape( mImageProcesada, 'rectangle', [eBoxProcesada.xmin, eBoxProcesada.ymin, eBoxProcesada.width, eBoxProcesada.height ], LineWidth=3, Color=["blue"] );

        if eBoxCropped.width < 0 | eBoxCropped.height < 0,  % The bounding box falls outside the image 
            tDataCropped.xmin(j) = 0;
            tDataCropped.xmax(j) = 0;
            tDataCropped.ymin(j) = 0;
            tDataCropped.ymax(j) = 0;
            tDataCropped.width(j) = 0;
            tDataCropped.height(j) = 0;
        else
            tDataCropped.xmin(j) = eBoxCropped.xmin;
            tDataCropped.xmax(j) = eBoxCropped.xmax;
            tDataCropped.ymin(j) = eBoxCropped.ymin;
            tDataCropped.ymax(j) = eBoxCropped.ymax;
            tDataCropped.width(j) = eBoxCropped.width;
            tDataCropped.height(j) = eBoxCropped.height;
        end

        if eBoxProcesada.width < 0 | eBoxProcesada.height < 0, % The bounding box falls outside the image 
            tDataProcesada.xmin(j) = 0;
            tDataProcesada.xmax(j) = 0;
            tDataProcesada.ymin(j) = 0;
            tDataProcesada.ymax(j) = 0;
            tDataProcesada.width(j) = 0;
            tDataProcesada.height(j) = 0;
        else
            tDataProcesada.xmin(j) = eBoxProcesada.xmin;
            tDataProcesada.xmax(j) = eBoxProcesada.xmax;
            tDataProcesada.ymin(j) = eBoxProcesada.ymin;
            tDataProcesada.ymax(j) = eBoxProcesada.ymax;
            tDataProcesada.width(j) = eBoxProcesada.width;
            tDataProcesada.height(j) = eBoxProcesada.height;
        end

        if lCentrada
            mImageComp = insertShape( mImageComp, 'rectangle', [eBoxImagen.xmin+eBoxCropped.xmin, eBoxImagen.ymin+eBoxCropped.ymin, eBoxProcesada.width, eBoxProcesada.height ; eBoxOriginal.xmin, eBoxOriginal.ymin, eBoxOriginal.width, eBoxOriginal.height ], LineWidth=3, Color=["yellow", "blue"] );
        else
            mImageComp = insertShape( mImageComp, 'rectangle', [eBoxProcesada.xmin, eBoxProcesada.ymin, eBoxProcesada.width, eBoxProcesada.height ; eBoxOriginal.xmin, eBoxOriginal.ymin, eBoxOriginal.width, eBoxOriginal.height ], LineWidth=3, Color=["yellow", "blue"] );
        end;     
    end;  
    
    % We show the original, cropped, processed images with their bounding boxes 
    if lFlag ==1
        close all; 
        figure; imshow( mImageOriginal,'DisplayRange', [] );
        figure; imshow( mImageCropped,'DisplayRange', [] );
        figure; imshow( mImageProcesada,'DisplayRange', [] );
        figure; imshow( mImageComp,'DisplayRange', [] );
        pause; 
    end; 
    tInfoCropped( vIdx, : ) = tDataCropped ;
    tInfoProcesado( vIdx, : ) = tDataProcesada ;
end; 

% Finally, we create new spreadsheets (.csv) for the new bounding boxes corresponding to the cropped and processed images 
% They are stored in the directory specified in sDirDestino
try 
    sTablaDestino = strcat( sDirDestino, sTablaDestinoCropped );
    writetable(tInfoCropped, sTablaDestino)
    sTablaDestino = strcat( sDirDestino, sTablaDestinoProcesado );
    writetable(tInfoProcesado, sTablaDestino)
catch
    disp( 'Error while generating the file with the new bounding boxes' );
end;     


