function VisuIlinPh(varargin)
% VisuIlinPh: visualisation composite de "l'intensité" et de la phase d'une image en amplitude complexe. (English help below)
% USAGE: VisuIlinPh(ImAC) ou VisuIlinPh(x,y,ImAC)
% x       : [OPTIONNEL] vecteur de 2 (ou n) éléments caractérisant les bornes horizontales de l'image à afficher
% y       : [OPTIONNEL] vecteur de 2 (ou m) éléments caractérisant les bornes verticales de l'image à afficher
%           Si x a plus que 2 éléments, seuls le premier et dernier élément est utilisé x=[x(1) x(end)]. Idem pour y.
%           ## x et y doivent être SIMULTANÉMENT présents ou absents. En cas d'absence, les valeurs par DÉFAUT
%           sont x=[1 n] et y=[1 m], où [m,n]=size(ImAC).    
% ImAC:      matrice complexe contenant l'image en amplitude complexe
% 
% L'affichage représente l'intensité (éclairement, |ImAC|²) par la luminosité de l'image et la phase sous la forme d'une couleur
% totalement saturée dans un espace de teinte périodique.
%+++++
% VisuIlinPh: Composite display of intensity and phase of a complex amplitude image.
% USE: VisuIlinPh(ImAC) ou VisuIlinPh(x,y,ImAC)
% x       : [OPTIONAL] vector of 2 (or n) elements that describes the horizontal axis limits of the image to display
% y       : [OPTIONAL] vector of 2 (or m) elements that describes the vertical axis limits of the image to display
%           If x as more than 2 elements, only the first and the last are used, i.e. x=[x(1) x(end)]. Same for y.
%           ## x and y must be SIMULTANEOUSLY present or absent. If they are missing, the default values are
%           x=[1 n] and y=[1 m], where [m,n]=size(ImAC).   
% ImAC    : complex matrix (of m×n size) that contains the complex data of the complex amplitude image to display.
% 
% This program displays the complex matrix ImAC with an image that shows the intensity (irradiance, |ImAC|²) with the pixel brightness
% and the phase with a saturated color in a periodic hue space.
%-----
% © Hervé SAUER - SupOptique - 16 avril 1999.
% + IOGS - H.S. - 24 mars 2013 : Ajout arguments optionnels x,y
% + IOGS - H.S. - 15 avril 2014: prise en compte du gamma écran et ajout "Emax=%1.1e"
% + IOGS - H.S. - 19 octobre 2014: adaptation à R2014b, correction hauteur trop grande colorbar en subplot
% + IOGS - H.S. - 21 octobre 2014: 'YDir'='norm' si x et y spécifiés, en-tête et msg_err bilingues Fr-Eng
%


% REMARQUE GÉNÉRALE: les images en vraies couleurs étant manipulées sous forme de
% tableaux à 3 dimensions de réels double précision, l'occupation mémoire peut
% rapidement devenir importante. La présente implémentation efface de manière
% systématique tout tableau temporaire dès qu'il n'a plus d'utilité.


switch nargin
  
  case 1
    AC=varargin{1};
    [m,n]=size(AC);
    x=[1 n];
    y=[1 m];
    YDir='reverse'; % convention affichage d'image, l'axe y pointe vers le bas
    
  case 3
    x=varargin{1};
    y=varargin{2};
    AC=varargin{3};
    YDir='normal'; % convention affichage fonction(x,y), l'axe y pointe vers le haut
    
  otherwise
    error(['Les seules syntaxes valides sont VisuIlinPh(ImAC) et VisuIlinPh(x,y,ImAC)' char(10)...
           'The only allowed calling syntaxes are VisuIlinPh(ImAC) and VisuIlinPh(x,y,ImAC)'])
end

%--------------------------------------------------------------------
% ÉTAPE 1: Création d'une image HSV (Hue Saturation Value) sous forme
%          d'un tableau Matlab à 3 dimensions.

E=real(AC.*conj(AC)); % tjs >= 0;
% real(…) pour supprimer des éventuelles parties imaginaires résiduelles dues aux
% erreurs d'arrondi...
maxE=max(E(:));
PlanV=E/maxE; % normalisation sur [0,1]. VALUE
clear E


Ph=angle(AC); % dans ]-pi,pi].
PlanH=(Ph+pi)/(2*pi); % normalisation sur [0,1].  HUE (ou teinte en français)
clear Ph


PlanS=ones(size(AC)); % SATURATION (tjs totale)

ImHSV=cat(3,PlanH,PlanS,PlanV);       clear PlanH PlanS PlanV
% L'image HSV est crée!


%--------------------------------------------------------------------
% ÉTAPE 2: Transformation de l'image HSV en image RGB par une transformation
%          colorimétrique classique.

ImRGB=trsf_sRGB_inverse(hsv2rgb(ImHSV));                 clear ImHSV



%--------------------------------------------------------------------
% ÉTAPE 3: Affichage de l'image RGB

% ## Pour permettre de relancer VisuIlinPh sur une figure déjà créé
% par VisuIlinPh ou VisuIdBPh, quelques précautions sont nécessaires:
axIm=gca;
axTag=get(axIm,'Tag'); % A une valeur spécial si VisuI__Ph déjà utilisé
tt=get(axIm,'UserData');

tesp=0.08; tech=0.075; tbrd=0.02;
% définitions générales pour l'espacement des axes 


switch axTag
  
case {'VisuIlinPh-lin','VisuIlinPh-Ph'}
  axIm=findobj(gcf,'Tag','VisuIlinPh-Image','UserData',tt);
  if length(axIm)~=1
    error('Il y a 0 ou plusieurs images ayant le même détrompeur')
  end
  axes(axIm)
  axTag=get(axIm,'Tag');
  
case {'VisuIdBPh-lin','VisuIdBPh-Ph','VisuIdBPh-Image'}
  axs=findobj(gcf,'UserData',tt);
  tgs=get(axs,'Tag');
  if length(axs)~=3 || ~all(strncmp(tgs,'VisuIdBPh',length('VisuIdBPh')))
    error('Il n''y a pas le bon compte d''axes avec le même détrompeur')
  else
    axIm=findobj(gcf,'Tag','VisuIdBPh-Image','UserData',tt);
    if length(axIm)~=1
      error('Il y a 0 ou plusieurs images ayant le même détrompeur')
    end
    delete(setdiff(axs,axIm)) % on efface les axes des deux échelles colorées
    
    axes(axIm)
    axTag=get(axIm,'Tag');
    p=get(axIm,'Position');
    p=[p(1) p(2) p(3)/(1-2*tesp-2*tech-tbrd) p(4)];
    set(axIm,'Position',p); % On restaure la taille initiale!!
  end
  
end

%AFFICHAGE DE L'IMAGE RGB proprement dit.
figure(gcf),image(x,y,ImRGB),axis image;  clear ImRGB
set(gca,'YDir',YDir)
set(gca,'TickDir','out')


%--------------------------------------------------------------------
% ÉTAPE 4: Mise en place des échelles de teintes pour légende Ecl/phase
%          (si elles ne sont pas déjà en place!)

if isequal(axTag,'VisuIlinPh-Image')
  
  % Les échelles sont déjà en place.
  % Il n'y a rien à faire (échelles fixes E_r: [0 1], phi: [-pi,pi]) sauf màj Emax
  tt=get(axIm,'UserData');
  haxEchEr=findobj(gcf,'Tag','VisuIlinPh-lin','UserData',tt);
  if isscalar(haxEchEr)
    hxLbl=get(haxEchEr,'xLabel');
    set(hxLbl,'String',{'max=' sprintf('%1.1e',maxE)}) % Modification; 'FontSize' déjà appliqué sur le label
  end
  
else
  
  % Les échelles n'existent pas. Il faut les créer.
  
  tt=now;
  
  u=get(axIm,'Units');set(axIm,'Units','Normalized');
  p=get(axIm,'Position');set(axIm,'Units',u);
  
  %tesp=0.08; tech=0.075; tbrd=0.02; DÉFINIS PLUS HAUT
  
  pIm=[p(1) p(2) p(3)*(1-2*tesp-2*tech-tbrd) p(4)];
  pElin=[p(1)+p(3)*(1-1*tesp-2*tech-tbrd) p(2) p(3)*tech p(4)];
  pEPh=[p(1)+p(3)*(1-tech-tbrd) p(2) p(3)*tech p(4)];
  
  
  set(axIm,'Position',pIm,'NextPlot','ReplaceChildren',...
    'Tag','VisuIlinPh-Image','UserData',tt)
  
  % Échelle des éclairements relatifs linéaire:
  axElin=axes('position',pElin);
  [PlanH,PlanV]=meshgrid(linspace(0,1,32),linspace(0,1,128));
  PlanS=ones(size(PlanH));
  EchHSV=cat(3,PlanH,PlanS,PlanV); clear PlanH PlanS PlanV
  % création de l'échelle "E_r" en HSV
  image([0 1],[0 1],trsf_sRGB_inverse(hsv2rgb(EchHSV))); clear EchHSV % puis affichage (en RGB).
  set(axElin,'YAxisLocation','right','Xtick',[],'Ydir','normal','TickDir','out',...
    'Tag','VisuIlinPh-lin','UserData',tt,...
    'NextPlot','ReplaceChildren',...
    'Ylim',[0 1],...
    'PlotBoxAspectRatio',[tech 0.7 1]);
  title(' I_{relatif}','FontWeight','normal') % Éclairement relatif (au maximum) [Sans Dimension]
  xlabel({'max=' sprintf('%1.1e',maxE)},'FontSize',8)
  
  % Échelle des phases:
  axEPh=axes('position',pEPh);
  [PlanV,PlanH]=meshgrid(linspace(0,1,32),linspace(0,1,128));
  PlanS=ones(size(PlanH));
  EchHSV=cat(3,PlanH,PlanS,PlanV); clear PlanH PlanS PlanV
  % création de l'échelle "Phase" en HSV
  image([0 1],[-180 180],trsf_sRGB_inverse(hsv2rgb(EchHSV))); clear EchHSV % puis affichage (en RGB).
  % minV correspond au minimum en lin de l'amplitude complexe normalisée.
  set(axEPh,'YAxisLocation','right','Xtick',[],'TickDir','out',...
    'Ydir','normal','Ytick',-180:45:180, ...
    'Tag','VisuIlinPh-Ph','UserData',tt,...
    'NextPlot','ReplaceChildren',...
    'PlotBoxAspectRatio',[tech 0.7 1]);
  title(' \Phi [°]','FontWeight','normal') % le mnémonique TEX \varphi n'est pas disponible
 
  
  
  axes(axIm) % On remet l'axe courant sur l'image (pour permettre de donner un titre, ...)
  
end






