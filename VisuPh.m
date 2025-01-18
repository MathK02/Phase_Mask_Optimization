function VisuPh(varargin)
% VisuPh:   visualise la phase d'une image en amplitude complexe.
% USAGE: VisuPh(ImAC)  ou   VisuPh(ImAC,type_LUT)   ou
%        VisuPh(x,y,ImAC)  ou   VisuPh(x,y,ImAC,type_LUT)
% x       : [OPTIONNEL] vecteur de 2 (ou n) éléments caractérisant les bornes horizontales de l'image à afficher
% y       : [OPTIONNEL] vecteur de 2 (ou m) éléments caractérisant les bornes verticales de l'image à afficher
%           Si x a plus que 2 éléments, seuls le premier et dernier élément est utilisé x=[x(1) x(end)]. Idem pour y.
%           ## x et y doivent être SIMULTANÉMENT présents ou absents. En cas d'absence, les valeurs par DÉFAUT
%           sont x=[1 n] et y=[1 m], où [m,n]=size(ImAC).    
% ImAC    : matrice complexe contenant l'image en amplitude complexe
% type_LUT: [OPTIONNEL]. chaîne de caractère 'g','c','p' ou 's', 'sR','sV'
%           pour Gris, Couleur, Périodique ou Sinusoïdale (gris, rouge ou vert)
%           caractérisant la LUT utilisée. (Par défaut la LUT est périodique).
%           {Majuscules ou minuscules indifférentes}
%+++++
% VisuPh:  displays the phase of a complex amplitude image
% USE:  VisuPh(ImAC)  or   VisuPh(ImAC,type_LUT)   or
%       VisuPh(x,y,ImAC)  or   VisuPh(x,y,ImAC,type_LUT)
% x       : [OPTIONAL] vector of 2 (or n) elements that describes the horizontal axis limits of the image to display
% y       : [OPTIONAL] vector of 2 (or m) elements that describes the vertical axis limits of the image to display
%           If x as more than 2 elements, only the first and the last are used, i.e. x=[x(1) x(end)]. Same for y.
%           ## x and y must be SIMULTANEOUSLY present or absent. If they are missing, the default values are
%           x=[1 n] and y=[1 m], where [m,n]=size(ImAC).   
% ImAC    : complex matrix (of m×n size) that contains the complex amplitude image to display.
% type_LUT: [OPTIONAL]. A character string 'g','c','p' ou 's', 'sR','sG'
%           for Grayed, Colored, Periodic  or  Sinusoidal (gray, red or green)
%           that defines the Look-Up-Table used for display. (Default: Periodic LUT).
%           {The string is case insensitive}
%-----
% © Hervé SAUER - SupOptique - 05 novembre 1997.
% + Ajout LUTs sinusoïdales  - HS - 06/11/2003
% + IOGS - H.S. - 24 mars 2013 : Ajout arguments optionnels x,y
% + IOGS - H.S. - 21 octobre 2014:  adaptation à R2014b,'YDir'='norm' si x et y spécifiés, en-tête et msg_err bilingues Fr-Eng
% + IOGS - H.S. - 02 avril 2018 - adaptation pour R2018a


switch nargin
  
  case {1,2}
    Ph=angle(varargin{1}); % évite de définir inutilement une variable AC
    if nargin < 2
      type_lut='P';
    else
      type_lut=varargin{2};
    end
    [m,n]=size(Ph);
    x=[1 n];
    y=[1 m];    
    YDir='reverse'; % convention affichage d'image, l'axe y pointe vers le bas
    
  case {3,4}
    x=varargin{1};
    y=varargin{2};
    YDir='normal'; % convention affichage fonction(x,y), l'axe y pointe vers le haut
    Ph=angle(varargin{3}); % évite de définir inutilement une variable AC
    if nargin < 4
      type_lut='P';
    else
      type_lut=varargin{4};
    end
  
  otherwise
    error(['La syntaxe requiert 1, 2, 3 ou 4 arguments d''entrée (voir l''aide en ligne)' char(10)...
           'The correct calling syntax required 1, 2, 3 or 4 input arguments (see online help)']) %#ok<*CHARTEN>
end


% Ph=angle(AC);


usg=1/1; %2.2; % facteur 1/gamma (c'est mieux avec 1 qu'avec 2.2 ... )

TL=lower(type_lut);
switch  TL
  case {'g','gris'}
    map=gray(256);
  case {'c','couleur'}
    map=jeths(256);
  case {'p','périodique','periodique'}
    map=hsv(256);
  case {'s','sinusoïdale','sinusoidale','sinus'}
    map=(0.5*(1+cos(linspace(-pi,pi,256).'))).^usg *[1 1 1]; % rampe sinusoïdale de GRIS
    % OK pour impression en N&B (au gamma près de l'imprimante...)
  case {'sr','sinusr'}
    map=(0.5*(1+cos(linspace(-pi,pi,256).'))).^usg *[1 0 0]; % rampe sinusoïdale de ROUGE
  case {'sv','sinusv','sg','sinusg'}
    map=(0.5*(1+cos(linspace(-pi,pi,256).'))).^usg *[0 1 0]; % rampe sinusoïdale de VERT
  otherwise
    error('L''argument "type_LUT" doit être / must exclusively be: ''g'', ''c'',''p'',''s'',''sR'', ''sV'', ''sG''.')
end

figure(gcf),imagesc(x,y,Ph,[-pi pi]),colormap(gca,map),axis image,h=colorbar;
set(gca,'YDir',YDir)
%# >=R2014b: le colormap(gca,¤) permet une LUT par axe dans le cas d'un subplot (syntaxe rétrocompatible avec Matlab < R2014b)
set(get(h,'YLabel'),'String','phase [radians]')
