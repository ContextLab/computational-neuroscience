function[]=izhikevich(varargin)
if nargin > 0 
	eval(varargin{1}); %execute the argument 
else
    main;
end;

%--------------------------------
function[]=main
global mode modeold pauseflag drawnull thresh quitflag 
global a b c d I v u VU L 
L = 500;
pauseflag=-1;
mode = 'A';
modeold=['0'];
drawnull=1;
quitflag=0;

pars=[0.02      0.2     -65      6       14 ;...    % tonic spiking
      0.02      0.25    -65      6       0.5 ;...   % phasic spiking
      0.02      0.2     -50      2       15 ;...    % tonic bursting
      0.02      0.25    -55     0.05     0.6 ;...   % phasic bursting
      0.02      0.2     -55     4        10 ;...    % mixed mode
      0.01      0.2     -65     8        30 ;...    % spike frequency adaptation
      0.02      -0.1    -55     6        0  ;...    % Class 1
      0.2       0.26    -65     0        0  ;...    % Class 2
      0.02      0.2     -65     6        7  ;...    % spike latency
      0.05      0.26    -60     0        0  ;...    % subthreshold oscillations
      0.1       0.26    -60     -1       0  ;...    % resonator
      0.02      -0.1    -55     6        0  ;...    % integrator
      0.03      0.25    -60     4        0;...      % rebound spike
      0.03      0.25    -52     0        0;...      % rebound burst
      0.03      0.25    -60     4        0  ;...    % threshold variability
      1         1.5     -60     0      -65  ;...    % bistability
        1       0.2     -60     -21      0  ;...    % DAP
      0.02      1       -55     4        0  ;...    % accomodation
     -0.02      -1      -60     8        80 ;...    % inhibition-induced spiking
     -0.026     -1      -45     0        80];       % inhibition-induced bursting

a=pars(1,1);
b=pars(1,2);
c=pars(1,3);
d=pars(1,4);
I=pars(1,5);
   


figNumber = figure(1);
clf;
set(figNumber,'NumberTitle','off','doublebuffer','on',...
        'Name','Simple Model by Izhikevich (2003)',...
        'Units','normalized','toolbar','figure',...
        'Position',[0.05 0.1 0.9 0.8]);
h1=subplot(4,2,1);
set(h1,'Position',[0.05 0.75 0.27 0.2])
vtrace=line('color','k','LineStyle','-','erase','background','xdata',[],'ydata',[],'zdata',[]);
axis([0 100 -100 30])
title('membrane potential, v')
xlabel('time (ms)');

h2=subplot(4,2,3);
set(h2,'Position',[0.05 0.5 0.27 0.15])
utrace=line('color','k','LineStyle','-','erase','background','xdata',[],'ydata',[],'zdata',[]);
axis([0 100 -40 60])
title('recovery variable, u')
xlabel('time (ms)')

h3=subplot(2,2,2);
set(h3,'Position',[0.4 0.5 0.55 0.45])
head = line('color','r','Marker','.','markersize',20,'erase','xor','xdata',[],'ydata',[],'zdata',[]);
tail=line('color','k','LineStyle','-','erase','xor','xdata',[],'ydata',[],'zdata',[]);
vnull=line('color','b','LineStyle','-','erase','xor','xdata',[],'ydata',[],'zdata',[]);
unull=line('color','b','LineStyle','-','erase','xor','xdata',[],'ydata',[],'zdata',[]);
cnull=line('color','g','LineStyle',':','erase','xor','xdata',[],'ydata',[],'zdata',[]);
thresh=line('color','r','LineStyle','-','erase','xor','xdata',[],'ydata',[],'zdata',[]);
axis([-100 0 -60 40]);
title('phase portrait')
xlabel('v');ylabel('u');

if exist('izhikevich.jpg')
    h=subplot(2,2,3);
    set(h,'Position',[0.05 0.05 0.2 0.37])
    fig1=imread('izhikevich.jpg');
    B=gray; mind=20;
    B(1:mind,:)=B(1:mind,:)/B(mind,1);
    colormap(1-B);
    imagesc(fig1);
    axis off;
else
    uicontrol('Style','frame', 'Units','normalized', ...
          'Position',[0.04  0.05 0.22 0.37]);
    disp(['Cannot find figure file <izhikevich.jpg>' 7]);
    uicontrol('Style','text', 'Units','normalized', 'HorizontalAlignment','center',...
          'Position',[0.05  0.28 0.17 0.02],'string',{'download picture izhikevich.jpg'});
    uicontrol('Style','text', 'Units','normalized', 'HorizontalAlignment','center',...
          'Position',[0.05  0.21 0.17 0.02],'string',{'or see Fig.1 in Izhikevich (2004)'});
    
end

uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+0*0.2/4  0.09+4*0.37/5 0.02 0.025],...
          'String','A','Callback','global mode; mode=''A'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+1*0.2/4  0.09+4*0.37/5 0.02 0.025],...
          'String','B','Callback','global mode; mode=''B'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+2*0.2/4  0.09+4*0.37/5 0.02 0.025],...
          'String','C','Callback','global mode; mode=''C'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+3*0.2/4  0.09+4*0.37/5 0.02 0.025],...
          'String','D','Callback','global mode; mode=''D'';');
      
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+0*0.2/4  0.09+3*0.37/5 0.02 0.025],...
          'String','E','Callback','global mode; mode=''E'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+1*0.2/4  0.09+3*0.37/5 0.02 0.025],...
          'String','F','Callback','global mode; mode=''F'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+2*0.2/4  0.09+3*0.37/5 0.02 0.025],...
          'String','G','Callback','global mode; mode=''G'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+3*0.2/4  0.09+3*0.37/5 0.02 0.025],...
          'String','H','Callback','global mode; mode=''H'';');
      
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+0*0.2/4  0.09+2*0.37/5 0.02 0.025],...
          'String','I','Callback','global mode; mode=''I'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+1*0.2/4  0.09+2*0.37/5 0.02 0.025],...
          'String','J','Callback','global mode; mode=''J'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+2*0.2/4  0.09+2*0.37/5 0.02 0.025],...
          'String','K','Callback','global mode; mode=''K'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+3*0.2/4  0.09+2*0.37/5 0.02 0.025],...
          'String','L','Callback','global mode; mode=''L'';');

uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+0*0.2/4  0.09+1*0.37/5 0.02 0.025],...
          'String','M','Callback','global mode; mode=''M'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+1*0.2/4  0.09+1*0.37/5 0.02 0.025],...
          'String','N','Callback','global mode; mode=''N'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+2*0.2/4  0.09+1*0.37/5 0.02 0.025],...
          'String','O','Callback','global mode; mode=''O'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+3*0.2/4  0.09+1*0.37/5 0.02 0.025],...
          'String','P','Callback','global mode; mode=''P'';');

uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+0*0.2/4  0.09+0*0.37/5 0.02 0.025],...
          'String','Q','Callback','global mode; mode=''Q'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+1*0.2/4  0.09+0*0.37/5 0.02 0.025],...
          'String','R','Callback','global mode; mode=''R'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+2*0.2/4  0.09+0*0.37/5 0.02 0.025],...
          'String','S','Callback','global mode; mode=''S'';');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.05+3*0.2/4  0.09+0*0.37/5 0.02 0.025],...
          'String','T','Callback','global mode; mode=''T'';');
      
 
      
uicontrol('Style','frame', 'Units','normalized', ...
          'Position',[0.27  0.05 0.12 0.37]);
uicontrol('Style','text', 'Units','normalized', 'HorizontalAlignment','left',...
          'tag','parameters','Position',[0.29  0.38 0.07 0.03],'string','parameters:');
      
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.35 0.03 0.03],'string','a=');
uicontrol('Style','edit', 'Units','normalized', ...
          'Position',[0.31  0.35 0.05 0.03],...
          'string',num2str(a),'tag','a','Callback','izhikevich(''changepars'')');
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.3 0.03 0.03],'string','b=');
uicontrol('Style','edit', 'Units','normalized', ...
          'Position',[0.31  0.3 0.05 0.03],...
          'string',num2str(b),'tag','b','Callback','izhikevich(''changepars'')');
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.25 0.03 0.03],'string','c=');
uicontrol('Style','edit', 'Units','normalized', ...
          'Position',[0.31  0.25 0.05 0.03],...
          'string',num2str(c),'tag','c','Callback','izhikevich(''changepars'')');
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.2 0.03 0.03],'string','d=');
uicontrol('Style','edit', 'Units','normalized', ...
          'Position',[0.31  0.2 0.05 0.03],...
          'string',num2str(d),'tag','d','Callback','izhikevich(''changepars'')');
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.15 0.03 0.03],'string','I=');
uicontrol('Style','edit', 'Units','normalized', ...
          'Position',[0.31  0.15 0.05 0.03],...
          'string',num2str(I),'tag','I','Callback','izhikevich(''changepars'')');
uicontrol('Style','text', 'Units','normalized', ...
          'Position',[0.28  0.1  0.05 0.03],...
          'String','current');
uicontrol('Style','radio', 'Units','normalized', ...
          'Position',[0.33  0.1  0.03 0.03],...
          'tag','current','value',0,'callback','global drawnull;drawnull=1;');
      

uicontrol('Style','frame', 'Units','normalized', ...
          'Position',[0.4  0.25 0.16 0.17]);
uicontrol('Style','text', 'Units','normalized', 'HorizontalAlignment','left',...
          'Position',[0.41  0.26 0.14 0.15],'string',{'simple model:';'';'v''=0.04v^2+5v+140-u+I';'u''=a(bv-u)';'';'if v=+30 mV (peak of AP)';'then v=c, u=u+d'});
      

uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.4  0.19 0.1 0.05],...
          'String','excitatory pulse','Callback','global v; v=v+10;');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.4  0.12 0.1 0.05],...
          'String','inhibitory pulse','Callback','global v; v=v-10;');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.4  0.05 0.1 0.05],...
          'String','initial point','Callback','global u v L VU; ic=ginput(1);v=ic(1);u=ic(2);VU = [v;u]*ones(1,L);');
      
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.57  0.37 0.1 0.05],...
          'tag','threshold','String','show threshold','Callback','izhikevich(''showthreshold'')');
      
      

      
uicontrol('Style','frame', 'Units','normalized', ...
          'Position',[0.52  0.12 0.31 0.05]);
uicontrol('Style','text', 'Units','normalized',...
          'Position',[0.525  0.145 0.3 0.02],'string','input current');
uicontrol('Style','text', 'Units','normalized','HorizontalAlignment','left',...
          'Position',[0.525  0.145 0.05 0.02],'string','-100');
uicontrol('Style','text', 'Units','normalized','HorizontalAlignment','right',...
          'Position',[0.775  0.145 0.05 0.02],'string','+100');
uicontrol('Style','slider', 'Units','normalized', ...
          'Position',[0.525  0.125 0.3 0.015],...
          'min',-100,'max',100,...
          'value',I, 'tag','inputcurrent','callback','izhikevich(''changepars(1)'')');
      
      
      
uicontrol('Style','frame', 'Units','normalized', ...
          'Position',[0.52  0.05 0.31 0.05]);
uicontrol('Style','text', 'Units','normalized',...
          'Position',[0.525  0.075 0.3 0.02],'string','visualization speed');
uicontrol('Style','slider', 'Units','normalized', ...
          'Position',[0.525  0.055 0.3 0.015],...
          'value',0.0, 'tag','speed');
      
      
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.85  0.12 0.1 0.05],...
          'String','pause','tag','pause','Callback','global pauseflag;pauseflag=-pauseflag;');
uicontrol('Style','pushbutton', 'Units','normalized', ...
          'Position',[0.85  0.05 0.1 0.05],...
          'String','quit','Callback','global quitflag;quitflag=1;');
      
      
v=-70;
u=-20;

VU = [v;u]*ones(1,L);
tau = 0.2;
t=0;

% The main loop
while quitflag==0
   pause(0.1*get(findobj('tag','speed'),'value')^1);
   
   p=findobj('tag','pause');
   while pauseflag>0
        pause(0);drawnow; %needed to overcome MATLAB7 bug (found by Gerardo Lafferriere) 
        set(p,'string','resume');
   end;
   set(p,'string','pause');
   
   if modeold ~= mode
        set(findobj('tag','parameters'),'string',['parameters: ' mode]);
        m=find('ABCDEFGHIJKLMNOPQRST'==mode);
        a=pars(m,1);set(findobj('tag','a'),'string',num2str(a));
        b=pars(m,2);set(findobj('tag','b'),'string',num2str(b));
        c=pars(m,3);set(findobj('tag','c'),'string',num2str(c));
        d=pars(m,4);set(findobj('tag','d'),'string',num2str(d));
        I=pars(m,5);set(findobj('tag','I'),'string',num2str(I));
        set(findobj('tag','inputcurrent'),'value',max(-100,min(100,I)));
        set(findobj('tag','current'),'value',0);
        modeold=mode;
        drawnull=1;
        set(h3, 'ylim', -b*62+[-30 70])
        set(h2, 'ylim', -b*62+[-30 70])
    end;
    if drawnull>0
        drawnull=0;
        vv=-100:1:0;
        set(vnull,'xdata',vv,'ydata',0.04*vv.^2+5*vv+140+I*get(findobj('tag','current'),'value'));
        vv=[-100 0];
        set(unull,'xdata',[-100 0],'ydata',b*[-100 0]);
        set(cnull,'xdata',[c c],'ydata',[-200 200]);
        drawnow;
   end;
   
   t=t+tau;
   v=v+tau*(0.04*v^2+5*v+140-u+I*get(findobj('tag','current'),'value'));
   u=u+tau*a*(b*v-u);
   if v>30
       v=c;
       u=u+d;
       VU(1,1)=31;
   end;    
   VU = [[v;u],VU(:,1:L-1)];
   
   VVU=VU; VVU(1,find(VU(1,:)>30))=NaN;
   set(vtrace,'xdata',tau*(L:-1:1),'ydata',VU(1,:));
   set(utrace,'xdata',tau*(L:-1:1),'ydata',VU(2,:));
   set(head,'xdata',VU(1,1),'ydata',VU(2,1))
   set(tail,'xdata',VVU(1,1:50),'ydata',VVU(2,1:50))
   drawnow; %needed to overcome MATLAB7 bug (found by Gerardo Lafferriere)
end;

%-----------------------------------
function changepars(inpcur)
global a b c d I drawnull
drawnull = 1;

obj=findobj('tag','a');
nv=str2num(get(obj,'string'));
if isempty(nv)
    nv=a;
end;
a=nv;
set(obj,'string',num2str(nv));

obj=findobj('tag','b');
nv=str2num(get(obj,'string'));
if isempty(nv)
    nv=b;
end;
b=nv;
set(obj,'string',num2str(nv));

obj=findobj('tag','c');
nv=str2num(get(obj,'string'));
if isempty(nv)
    nv=c;
end;
c=nv;
set(obj,'string',num2str(nv));

obj=findobj('tag','d');
nv=str2num(get(obj,'string'));
if isempty(nv)
    nv=d;
end;
d=nv;
set(obj,'string',num2str(nv));

if nargin <1
    obj=findobj('tag','I');
    nv=str2num(get(obj,'string'));
    if isempty(nv)
        nv=I;
    end;
    I=max(-100,min(100,nv));
    set(obj,'string',num2str(I));
    set(findobj('tag','inputcurrent'),'value',I);
else
    I = get(findobj('tag','inputcurrent'),'value');
    set(findobj('tag','I'),'string',num2str(I));
end;


%------------------------------------------------
function showthreshold
global a b c d I
global thresh
obj = findobj('tag','threshold');
if get(obj,'String')=='hide threshold'
    set(obj,'string','show threshold');
    set(thresh,'xdata',[],'ydata',[]);
else
    D=(5-b)^2-4*(140+I*get(findobj('tag','current'),'value'))*0.04;
    if D < 0
        set(thresh,'xdata',[],'ydata',[]);
    else
        set(obj,'string','hide threshold');
        thv = (-(5-b)+D^0.5)/(2*0.04);
        L= [2*0.04*thv+5, -1; a*b, -a];
        [vect,lam]=eig(L);
        thVUp=[];
        thVUm=[];
        vp = thv+2*vect(1,2);
        up = b*thv+2*vect(2,2);
        vm = thv-2*vect(1,2);
        um = b*thv-2*vect(2,2);
        while (abs(vp) < 100) & (abs(vm) < 100)
            vp=vp-0.2*(0.04*vp^2+5*vp+140-up+I*get(findobj('tag','current'),'value'));
            up=up-0.2*a*(b*vp-up);
            thVUp = [thVUp; vp,up];
            vm=vm-0.2*(0.04*vm^2+5*vm+140-um+I*get(findobj('tag','current'),'value'));
            um=um-0.2*a*(b*vm-um);
            thVUm = [thVUm; vm,um];
            set(thresh,'xdata',[thVUm(end:-1:1,1);thVUp(:,1)],'ydata',[thVUm(end:-1:1,2);thVUp(:,2)]);
       end;
     end;
end;