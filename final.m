% Aaron Valdes,
% April 27th, 2019
% BME 211 KX, Spring 2019
% Final
function varargout = final(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @final_OpeningFcn, ...
    'gui_OutputFcn',  @final_OutputFcn, ...
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
function final_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
global inputfiles1;
global filePattern2;
global f;
% Gets the directory where you want to obtain your file
f=uigetdir(); 
% Makes the file format to load the file based on the directory provided
filePattern = fullfile(f, '*.tif');
filePattern2 = fullfile(f, 'mit200.mat');
inputfiles1 = dir(filePattern);
%if the file that has the value of g exist delete it
if exist('value.mat')==2
            delete('value.mat')
end

function varargout = final_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function ct_slider_Callback(hObject, eventdata, handles)
% Makes the values of the slider to be integers
val=round(hObject.Value);
hObject.Value=val;
global inputfiles1;
global f;
% Gets handle number
slidernumber=get(handles.ct_slider,'Value');
baseFileName = inputfiles1(slidernumber).name;
fullFileName = fullfile(f, baseFileName);
imageArray = imread(fullFileName);
axes(handles.axes2)
imshow(imageArray);
%Display slide number
set(handles.slidenumber_text,'String',slidernumber);

function ct_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function togglebutton1_Callback(hObject, eventdata, handles)
set(handles.togglebutton1,'String','Stop');
set(handles.togglebutton1,'ForegroundColor','red');
button_state=get(handles.togglebutton1,'Value');
global filePattern2;
load(filePattern2);
ecgsigfiltered=movmean(ecgsig,20);
%Initialize the value of g
g=1;
% If the file that has the value of g exist then load it
if exist('value.mat')==2
    load('value.mat')
end
for n=g:1:numel(tm)
    %check for the buttonstate
    if(button_state==1)
    axes(handles.axes1)
    plot(tm(n:n+600),ecgsigfiltered(n:n+600))
    xlabel('Time(sec)')
    ylabel('Amplitude(mV)')
    grid on;
    xlim([tm(n) tm(n+600)])
    ylim([-2.5 2.5])
    pause(0.05)
    button_state=get(handles.togglebutton1,'Value');
    if n==numel(tm)
        if exist('value.mat')==2
            delete('value.mat')
            set(handles.togglebutton1,'String','Finished');
            set(handles.togglebutton1,'ForegroundColor','green');
        end
    end
    else
        set(handles.togglebutton1,'String','Resume');
        set(handles.togglebutton1,'ForegroundColor','blue');
        button_state=get(handles.togglebutton1,'Value');
        g=n;
        save('value.mat','g');
        break
    end
end
