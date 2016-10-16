function varargout = SCORE(varargin)
% SCORE M-file for SCORE.fig
%      SCORE, by itself, creates a new SCORE or raises the existing
%      singleton*.
%
%      H = SCORE returns the handle to a new SCORE or the handle to
%      the existing singleton*.
%
%      SCORE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCORE.M with the given input arguments.
%
%      SCORE('Property','Value',...) creates a new SCORE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCORE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCORE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCORE

% Last Modified by GUIDE v2.5 20-Sep-2010 10:55:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCORE_OpeningFcn, ...
                   'gui_OutputFcn',  @SCORE_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%setting anti-aliasing for the curves:
set(0,'DefaultLineLineSmoothing','on');
set(0,'DefaultPatchLineSmoothing','on');

% End initialization code - DO NOT EDIT

 
% --- Executes just before SCORE is made visible.
function SCORE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCORE (see VARARGIN)

% Choose default command line output for SCORE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCORE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCORE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddFiles.
function AddFiles_Callback(hObject, eventdata, handles)
% hObject    handle to AddFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[input_file,pathname,filterindex] = uigetfile({'*.txt', 'Text (*.txt)'; '*.*', 'All Files (*.*)'},'Select files', 'MultiSelect', 'on');

%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end
 
%gets the current data file names inside the listbox
inputFileNames = get(handles.listbox1,'String');


   if iscell(input_file)==0
       for n = 1:length(inputFileNames)
        if strcmp(inputFileNames{n},fullfile(pathname,input_file))
            msgbox('selected file already exist in the list!','File already imported', 'warn');
            return ;
        end
       end
   else
      for n = 1:length(inputFileNames)
       for p=1:length(input_file)
           if strcmp(inputFileNames{n},fullfile(pathname,input_file{p}))
               msgbox('some of selected files already exists in the list!','Files already imported', 'warn');
               return ;
           end
       end
   end
end

%if they only select one file, then the data will not be a cell
%if more than one file selected at once,
%then the data is stored inside a cell
if iscell(input_file) == 0
 
    %add the most recent data file selected to the cell containing
    %all the data file names
    inputFileNames{end+1} = fullfile(pathname,input_file);
 
%else, data will be in cell format
else
    %stores full file path into inputFileNames
    for n = 1:length(input_file)
        %notice the use of {}, because we are dealing with a cell here!
        inputFileNames{end+1} = fullfile(pathname,input_file{n});
    end
end
 
%updates the gui to display all filenames in the listbox
set(handles.listbox1,'String',inputFileNames);
 
%make sure first file is always selected so it doesn't go out of range
%the GUI will break if this value is out of range
set(handles.listbox1,'Value',1);
 
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in RemoveFile.
function RemoveFile_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputFileNames = get(handles.listbox1,'String');
 
%get the values for the selected file names
option = get(handles.listbox1,'Value');
 
%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 || isempty(inputFileNames))
    return
end
 
%erases the contents of highlighted item in data array
inputFileNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.listbox1,'String',inputFileNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(inputFileNames)
    set(handles.listbox1,'Value',length(inputFileNames));
end
 
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ChangeClassification.
function ChangeClassification_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeClassification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(getappdata(0,'defaultdata')))
    default_data;
end

sub_gui();

% --- Executes on button press in ExportResults.
function ExportResults_Callback(hObject, eventdata, handles)
% hObject    handle to ExportResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selecting file where data will be written
[input_file,pathname,filterindex] = uiputfile({'*.csv', 'csv/text (*.csv)'; '*.*', 'All Files (*.*)'},'Select file');
%getting data from GUI
tableData=get(handles.uitable1,'data');
%getting names from GUI
names=get(handles.uitable1,'RowName');
%creating cell with previous data
cell=[names, tableData];
%creating colons' names
tmp = {'filename','SCORE','FM','AUC','Rgauss','pNN50','Wgauss1','Wgauss2','Wgauss3','Prevision'};
%concatenation into final table
finalcell=vertcat(tmp,cell);
%writing to csv file
cell2csv(fullfile(pathname,input_file),finalcell,' ',2007);

        
%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end

% --- Executes on button press in PlotHistogram.
function PlotHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to PlotHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tableData=get(handles.uitable1,'data');
names=get(handles.uitable1,'ColumnName');
inputFileNames = get(handles.listbox1,'String');
if(names{1}=='SCORE')
    figure;
    for i=1:length(inputFileNames)
        data(i)=tableData{i,1};
    end
    histfit(data,10);    
else
    msgbox('calculate SCOREs first!','Error', 'error');
end

% --- Executes on button press in CalculateSCOREs.
function CalculateSCOREs_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateSCOREs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isempty(getappdata(0,'defaultdata')))
     default_data;
end
paramsvec=getScoreParams(handles);
fenetre1=str2double(get(handles.a1Rgauss,'String'));
fenetre2=str2double(get(handles.a2Rgauss,'String'));
window=str2double(get(handles.window,'String'));
%treating all files, simillar case to the previous one
inputFileNames = get(handles.listbox1,'String');
if isempty(inputFileNames)
    msgbox('there are no files in the list!','Error', 'error');
    return ;
else
    %disabling buttons that one cannnot modify values of editboxes, or
    %press other buttons in the meantime
    disableButtons(handles);
    %refreshing gui
    refresh;
    len=length(inputFileNames);
    FMvec=zeros(1,len);
    AUCvec=zeros(1,len);
    SCOREvec=zeros(1,len);
    pNN50vec=zeros(1,len);
    Wgauss1=zeros(1,len);
    Wgauss2=zeros(1,len);
    Wgauss3=zeros(1,len);
    Rgauss=zeros(1,len);
    

    
    for i=1:len
        %show progressbar
        stopBar= progressbar(i/len,0);
        if (stopBar) break; end
    
        path = inputFileNames{i};
        [FM AUC NN50 pNN50 Rgauss Wgauss1 Wgauss2 Wgauss3]=calcEquation(path,fenetre1,fenetre2,paramsvec(6),paramsvec(8),paramsvec(10),window);
        [cFM cAUC cpNN50 cRgauss cWgauss1 cWgauss2 cWgauss3]=calc_code_coleurs(FM,AUC,pNN50,Rgauss,Wgauss1,Wgauss2,Wgauss3);
  
        
        SCORE=paramsvec(1)*cFM+paramsvec(2)*cAUC+paramsvec(3)*cRgauss+paramsvec(4)*cpNN50+paramsvec(5)*cWgauss1+paramsvec(7)*cWgauss2+paramsvec(9)*cWgauss3;
        
        FMvec(i)=FM;
        AUCvec(i)=AUC;
        SCOREvec(i)=SCORE;
        pNN50vec(i)=pNN50;
        NN50vec(i)=NN50;
        Rgaussvec(i)=Rgauss;
        Wgauss1vec(i)=Wgauss1;
        Wgauss2vec(i)=Wgauss2;
        Wgauss3vec(i)=Wgauss3;
        str=regexp(inputFileNames{i},'\','split');
        filenames(i)=str(length(str));  
    end
    filenames{i+2}='min';
    filenames{i+3}='max';
    filenames{i+4}='STD';
    filenames{i+5}='mean';
    filenames{i+6}='median';
    
    %set the row labels
    set(handles.uitable1,'RowName',filenames);
    %do the same for the column headers
    columnHeaders = {'SCORE','FM','AUC','Rgauss','pNN50','Wgauss1','Wgauss2','Wgauss3','Prevision'};
    set(handles.uitable1,'ColumnName',columnHeaders);
    %changing alterability of proper colons
    set(handles.uitable1,'ColumnEditable',logical([0 0 0 0 0 0 0 0 1]));
    %associating all valuess
    for i=1:len
        tableData{i,1}=SCOREvec(i);
        tableData{i,2}=FMvec(i);
        tableData{i,3}=AUCvec(i);
        tableData{i,4}=Rgaussvec(i);
        tableData{i,5}=pNN50vec(i);
        tableData{i,6}=Wgauss1vec(i);
        tableData{i,7}=Wgauss2vec(i);
        tableData{i,8}=Wgauss3vec(i);
        tableData{i,9}=0;
        
    end
    
    tableData{len+2,1}=min(SCOREvec);
    tableData{len+2,2}=min(FMvec);
    tableData{len+2,3}=min(AUCvec);
    tableData{len+2,4}=min(Rgaussvec);
    tableData{len+2,5}=min(pNN50vec);
    tableData{len+2,6}=min(Wgauss1vec);
    tableData{len+2,7}=min(Wgauss2vec);
    tableData{len+2,8}=min(Wgauss3vec);
    
    
    tableData{len+3,1}=max(SCOREvec);
    tableData{len+3,2}=max(FMvec);
    tableData{len+3,3}=max(AUCvec);
    tableData{len+3,4}=max(Rgaussvec);
    tableData{len+3,5}=max(pNN50vec);
    tableData{len+3,6}=max(Wgauss1vec);
    tableData{len+3,7}=max(Wgauss2vec);
    tableData{len+3,8}=max(Wgauss3vec);
    
    tableData{len+4,1}=std(SCOREvec);
    tableData{len+4,2}=std(FMvec);
    tableData{len+4,3}=std(AUCvec);
    tableData{len+4,4}=std(Rgaussvec);
    tableData{len+4,5}=std(pNN50vec);
    tableData{len+4,6}=std(Wgauss1vec);
    tableData{len+4,7}=std(Wgauss2vec);
    tableData{len+4,8}=std(Wgauss3vec);
    
    
    tableData{len+5,1}=mean(SCOREvec);
    tableData{len+5,2}=mean(FMvec);
    tableData{len+5,3}=mean(AUCvec);
    tableData{len+5,4}=mean(Rgaussvec);
    tableData{len+5,5}=mean(pNN50vec);
    tableData{len+5,6}=mean(Wgauss1vec);
    tableData{len+5,7}=mean(Wgauss2vec);
    tableData{len+5,8}=mean(Wgauss3vec);
    
    tableData{len+6,1}=median(SCOREvec);
    tableData{len+6,2}=median(FMvec);
    tableData{len+6,3}=median(AUCvec);
    tableData{len+6,4}=median(Rgaussvec);
    tableData{len+6,5}=median(pNN50vec);
    tableData{len+6,6}=median(Wgauss1vec);
    tableData{len+6,7}=median(Wgauss2vec);
    tableData{len+6,8}=median(Wgauss3vec);
    
    
    %update the table
    set(handles.uitable1,'data',tableData);
    enableButtons(handles);
end


function cFM_Callback(hObject, eventdata, handles)
% hObject    handle to cFM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cFM as text
%        str2double(get(hObject,'String')) returns contents of cFM as a double


% --- Executes during object creation, after setting all properties.
function cFM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cFM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cAUC_Callback(hObject, eventdata, handles)
% hObject    handle to cAUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cAUC as text
%        str2double(get(hObject,'String')) returns contents of cAUC as a double


% --- Executes during object creation, after setting all properties.
function cAUC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cAUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cRgauss_Callback(hObject, eventdata, handles)
% hObject    handle to cRgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cRgauss as text
%        str2double(get(hObject,'String')) returns contents of cRgauss as a double


% --- Executes during object creation, after setting all properties.
function cRgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cRgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cpNN50_Callback(hObject, eventdata, handles)
% hObject    handle to cpNN50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cpNN50 as text
%        str2double(get(hObject,'String')) returns contents of cpNN50 as a double


% --- Executes during object creation, after setting all properties.
function cpNN50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpNN50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to p1Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1Wgauss as text
%        str2double(get(hObject,'String')) returns contents of p1Wgauss as a double


% --- Executes during object creation, after setting all properties.
function p1Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to p2Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2Wgauss as text
%        str2double(get(hObject,'String')) returns contents of p2Wgauss as a double


% --- Executes during object creation, after setting all properties.
function p2Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p3Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to p3Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p3Wgauss as text
%        str2double(get(hObject,'String')) returns contents of p3Wgauss as a double


% --- Executes during object creation, after setting all properties.
function p3Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1Rgauss_Callback(hObject, eventdata, handles)
% hObject    handle to a1Rgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1Rgauss as text
%        str2double(get(hObject,'String')) returns contents of a1Rgauss as a double


% --- Executes during object creation, after setting all properties.
function a1Rgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1Rgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2Rgauss_Callback(hObject, eventdata, handles)
% hObject    handle to a2Rgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2Rgauss as text
%        str2double(get(hObject,'String')) returns contents of a2Rgauss as a double


% --- Executes during object creation, after setting all properties.
function a2Rgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2Rgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotGaussians.
function PlotGaussians_Callback(hObject, eventdata, handles)
% hObject    handle to PlotGaussians (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fenetre=str2double(get(handles.window,'String'));
if (exist('f1')) 
    clear f1;
end

inputFileNames = get(handles.listbox1,'String');

%get the values for the selected file names
option = get(handles.listbox1,'Value');
 
%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 || isempty(inputFileNames))
    msgbox('there are no files in the list!','Error', 'error');
    return
end

path = inputFileNames{option};
%calculating cardiac frequency
[fc]=calculateFc(path);
%calculating gaussians in 'fenetre' minute observation window
N = length(fc);
i = 0;
arr = N/fenetre;
x=[0:0.01:250];
f1=figure(1);


clear str;
FM=0;
FMval=0;
for i=1:(arr-1)
    Moy=mean(fc((i-1)*fenetre+1:i*fenetre)); % moyennage de la fenetre
    Ec = std(fc((i-1)*fenetre+1:i*fenetre));
    Vmoy(i)=Moy;
    Vec(i)=Ec;
    FN=(1/(Ec*sqrt(2*pi))).*exp(-1/(2*Ec.^2)*(x-Moy).^2);% on cree la matrice contenant la gaussienne
    plot(x,FN)
    hold on
    
end
hold off
str=regexp(inputFileNames{option},'\','split');
str=strcat(str(length(str)),{' evolution of gaussian curves on '});
str=strcat(str(length(str)),num2str(fenetre));
str=strcat(str(length(str)),' mn window');
ylabel('Probability', 'FontSize',8, 'FontWeight','bold');        
xlabel('Puls/min', 'FontSize', 8,  'FontWeight','bold');
title(str,'FontSize',8, 'FontWeight','bold','Color','b');
clear inputFileNames fc N i arr x FM FMval Moy Ec Vmoy Vec FN


function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window as text
%        str2double(get(hObject,'String')) returns contents of window as a double


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ValidateClassification.
function ValidateClassification_Callback(hObject, eventdata, handles)
% hObject    handle to ValidateClassification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function c1Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to c1Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1Wgauss as text
%        str2double(get(hObject,'String')) returns contents of c1Wgauss as a double


% --- Executes during object creation, after setting all properties.
function c1Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to c2Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2Wgauss as text
%        str2double(get(hObject,'String')) returns contents of c2Wgauss as a double


% --- Executes during object creation, after setting all properties.
function c2Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c3Wgauss_Callback(hObject, eventdata, handles)
% hObject    handle to c3Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c3Wgauss as text
%        str2double(get(hObject,'String')) returns contents of c3Wgauss as a double


% --- Executes during object creation, after setting all properties.
function c3Wgauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c3Wgauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [ScoreParams]=getScoreParams(handles)
ScoreParams=zeros(1,10);
ScoreParams(1)=str2double(get(handles.cFM,'String'));
ScoreParams(2)=str2double(get(handles.cAUC,'String'));
ScoreParams(3)=str2double(get(handles.cRgauss,'String'));
ScoreParams(4)=str2double(get(handles.cpNN50,'String'));
ScoreParams(5)=str2double(get(handles.c1Wgauss,'String'));
ScoreParams(6)=str2double(get(handles.p1Wgauss,'String'));
ScoreParams(7)=str2double(get(handles.c2Wgauss,'String'));
ScoreParams(8)=str2double(get(handles.p2Wgauss,'String'));
ScoreParams(9)=str2double(get(handles.c3Wgauss,'String'));
ScoreParams(10)=str2double(get(handles.p3Wgauss,'String'));


function disableButtons(handles)
%change the mouse cursor to an hourglass
set(handles.figure1,'Pointer','watch');
 
%disable all the buttons so they cannot be pressed
set(handles.AddFiles,'Enable','off');
set(handles.RemoveFile,'Enable','off');
set(handles.CalculateSCOREs,'Enable','off');
set(handles.ExportResults,'Enable','off');
set(handles.PlotHistogram,'Enable','off');
set(handles.ChangeClassification,'Enable','off');
set(handles.PlotGaussians,'Enable','off');
set(handles.CalculateCoefficients,'Enable','off');
 
function enableButtons(handles)
%change the mouse cursor to an arrow
set(handles.figure1,'Pointer','arrow');
 
%enable all the buttons so they can be pressed
set(handles.PlotHistogram,'Enable','on');
set(handles.AddFiles,'Enable','on');
set(handles.RemoveFile,'Enable','on');
set(handles.CalculateSCOREs,'Enable','on');
set(handles.ExportResults,'Enable','on');
set(handles.ChangeClassification,'Enable','on');
set(handles.PlotGaussians,'Enable','on');
set(handles.CalculateCoefficients,'Enable','on');
 
function [Fc]=calculateFc(path)

[temps, interval]=readfile(path);

%temps au dessus de multiplicite des minutes
reste = mod(temps(length(temps)),60);

temps_max = temps(length(temps),1)-reste;

% pulsation du coeur en minutes
fc=zeros((temps_max)/60+1,1);


fcsec=zeros(temps(length(temps(:,1))),1);

%calculation de nombre des pulstions chaque seconde
for i=1:(length(temps(:,1))-1)
        fcsec(temps(i+1,1))=fcsec(temps(i+1,1))+1;
end


% on calcule fc (beats/minutes)
for i=1:length(temps)
    indice=floor(temps(i,1)/60)+1;
    fc(indice)=fc(indice)+1;
end



%on supprime derniere minute, puisque on n'aura pas toujours entier nombre
%de minutes echantillone
fc(length(fc))=[];
for i=length(temps):1
    if temps(i,1) >= (length(fc)*60)
        temps(i,1) = [];
    end
end

%on supprime les fréquences cardiaque qui sont inferieurs au 35 - on les
%traite comme les erreurs dans l'enregistrement.
fc(fc<=35)=[];
Fc=fc;

function [temps, interval]=readfile(path)

[HH, MM, SS, interval]= textread(path, '%2d:%2d:%2d\t%d%*[^\n]', 'headerlines', 2); % acquisition du data

heure_debut = HH(1);

% on cherche la minuit
for i=2:length(interval)
    if (HH(i-1,1)== 23) && (HH(i,1)==00) 
        break ;
    end
end

% on ajoute 24 heures apres la minuit parce que on a nouveau journee
for p=i:length(interval)
    HH(p,1) = HH(p,1) + 24;
end

temps = HH.*3600 + MM.*60 + SS; % normalisation du temps en secondes


% normalisation vers point 0;
temps11=temps(1,1);
for i=1:length(temps)
    temps(i,1)=temps(i,1) - temps11;
end

function default_data
%assigning initial values for colour codes
setappdata(0,'defaultdata',1);


setappdata(0,'FMgL',0);
setappdata(0,'FMgU', 70);
setappdata(0,'FMyL', 70);
setappdata(0,'FMyU', 75);
setappdata(0,'FMoL', 75);
setappdata(0,'FMoU', 80);
setappdata(0,'FMrL', 80);
setappdata(0,'FMrU', 250);
setappdata(0,'AUCgL', 2);
setappdata(0,'AUCgU', 50);
setappdata(0,'AUCyL', 1);
setappdata(0,'AUCyU', 2);
setappdata(0,'AUCoL', 0.5);
setappdata(0,'AUCoU', 1);
setappdata(0,'AUCrL', 0);
setappdata(0,'AUCrU', 0.5);
setappdata(0,'pNN50gL', 3);
setappdata(0,'pNN50gU', 15);
setappdata(0,'pNN50yL', 15);
setappdata(0,'pNN50yU', 23);
setappdata(0,'pNN50oL', 23);
setappdata(0,'pNN50oU', 30);
setappdata(0,'pNN50rL', 30);
setappdata(0,'pNN50rU', 100);
RgaussMediane = 3.84;
setappdata(0,'RgaussgL', 0.5*RgaussMediane);
setappdata(0,'RgaussgU', 1.2*RgaussMediane);
setappdata(0,'RgaussyL', 1.2*RgaussMediane);
setappdata(0,'RgaussyU', 1.5*RgaussMediane);
setappdata(0,'RgaussoL', 1.5*RgaussMediane);
setappdata(0,'RgaussoU', 1.7*RgaussMediane);
setappdata(0,'RgaussrL', 1.7*RgaussMediane);
setappdata(0,'RgaussrU', 5*RgaussMediane);

Wgauss1Mediane = 32.17;
setappdata(0,'Wgauss1gL', 0.9*Wgauss1Mediane);
setappdata(0,'Wgauss1gU', 5*Wgauss1Mediane);
setappdata(0,'Wgauss1yL', 0.7*Wgauss1Mediane);
setappdata(0,'Wgauss1yU', 0.9*Wgauss1Mediane);
setappdata(0,'Wgauss1oL', 0.5*Wgauss1Mediane);
setappdata(0,'Wgauss1oU', 0.7*Wgauss1Mediane);
setappdata(0,'Wgauss1rU', 0.5*Wgauss1Mediane);
setappdata(0,'Wgauss1rL', 0);

Wgauss2Mediane = 9.9;
setappdata(0,'Wgauss2gL', 0*Wgauss2Mediane);
setappdata(0,'Wgauss2gU', 1*Wgauss2Mediane);
setappdata(0,'Wgauss2yL', 1*Wgauss2Mediane);
setappdata(0,'Wgauss2yU', 1.2*Wgauss2Mediane);
setappdata(0,'Wgauss2oL', 1.2*Wgauss2Mediane);
setappdata(0,'Wgauss2oU', 1.4*Wgauss2Mediane);
setappdata(0,'Wgauss2rU', 5*Wgauss2Mediane);
setappdata(0,'Wgauss2rL', 1.4*Wgauss2Mediane);

Wgauss3Mediane = 2.38;
setappdata(0,'Wgauss3gL', 0*Wgauss3Mediane);
setappdata(0,'Wgauss3gU', 1*Wgauss3Mediane);
setappdata(0,'Wgauss3yL', 1*Wgauss3Mediane);
setappdata(0,'Wgauss3yU', 1.2*Wgauss3Mediane);
setappdata(0,'Wgauss3oL', 1.2*Wgauss3Mediane);
setappdata(0,'Wgauss3oU', 1.4*Wgauss3Mediane);
setappdata(0,'Wgauss3rU', 5*Wgauss3Mediane);
setappdata(0,'Wgauss3rL', 1.4*Wgauss3Mediane);


% --- Executes on button press in CalculateCoefficients.
function CalculateCoefficients_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateCoefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inputFileNames = get(handles.listbox1,'String');
tableData = get(handles.uitable1,'data');
len = length(inputFileNames);
prevision=zeros(1,len);
FM=zeros(1,len);
AUC=zeros(1,len);
for i=1:len
    prevision(i)=tableData{i,9};
    FM(i)=tableData{i,2};
    AUC(i)=tableData{i,3};
    Rgauss(i) = tableData{i,4};
    Wgauss1(i) = tableData{i,6};
    Wgauss2(i) = tableData{i,7};
    Wgauss3(i) = tableData{i,8};
    pNN50(i)= tableData{i,5};
end


X=[FM' AUC' Rgauss' Wgauss1' Wgauss2' Wgauss3' pNN50'];
b=regress(prevision',X);


%setting FM
set(handles.cFM,'String',num2str(b(1)));
%setting AUC
set(handles.cAUC,'String',num2str(b(2)));
%setting Rgauss
set(handles.cRgauss,'String',num2str(b(3)));
%setting Wgauss1
set(handles.c1Wgauss,'String',num2str(b(4)));
%setting Wgauss2
set(handles.c2Wgauss,'String',num2str(b(5)));
%setting Wgauss3
set(handles.c3Wgauss,'String',num2str(b(6)));
%setting pNN50
set(handles.cpNN50,'String',num2str(b(7)));
msgbox('Done !');

