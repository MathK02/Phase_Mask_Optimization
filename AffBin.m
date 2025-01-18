function AffBin(r)
% AffBin - affiche la constitution binaire de réels de type "double" ou "single" (IEEE 754-1985|2008) {English help below}
% USAGE: AffBin(r)
% r : scalaire numérique ou un tableau numérique (impérativement de type "double array" ou "single array")
%     Dans le cas d'un tableau, les éléments de r sont imprimés à raison d'un par ligne dans
%     la limite des 20 premiers.
%
% Rq: Uniquement testé sur machine à stockage little-endian (e.g. processeurs Intel ou AMD).
%+++++
% AffBin: display the binary representation of real numbers of type "double" ou "single" float (IEEE 754-1985|2008)
% USE: AffBin(r)
% r : numeric scalar or array, mandatorily of type "double" ou "single" (integer types not supported)
%     If  r  is an array, the first elements of  r  are printed with one number per line, with a maximum of 20 lines.
%
% NOTA: This function has only been checked on hardware with little-endian memory storage (e.g. Intel or AMD processors).
%-----
% © Hervé SAUER - SupOptique - 23 novembre 2016 (d'après AffBin 23/10/2002 + 31/07/2010(single) + 22/10/2014(bilingue))
% (Simplification de la détermination de la structure binaire du réel par utilisation d'un "typecast" de double vers uint64
%  ou single vers uint32)

switch class(r)
  
  case 'double'
    TC='uint64';
    nTC=64;
    
  case 'single'
    TC='uint32';
    nTC=32;
    
  otherwise
      error(['L''argument doit être de type "double" ou "single"!' char(10) ...
         'The input argument must mandatorily be of type "double" or "single"!'])
end


[~,~,Endianness]=computer; % Little or Big -Endian
if strcmpi(Endianness,'B')  % NOTA: Programme jamais testé sur machine de type Big-Endian (PC Win, PC Linux, Mac récent sont Little-E)
  r=swapbytes(r);
end


if isscalar(r) % r est scalaire
  
  rb=sprintf('%1d',bitget(typecast(r,TC),nTC:-1:1)); % ## nouvelle méthode Nov2016, beaucoup plus simple que le passage par hex précédent
  
  if rb(1)=='0'
    s='+';
  else
    s='-';
  end
  
  switch class(r)
    
    case 'double'  % IEEE 754
      
      expb=rb(2:12);
      nexp=bin2dec(expb)-1023;
      mantb=rb(13:end);
      
      rd=sprintf('%+25.16E(décimal)',r); % la valeur décimale avec TOUS les chiffres

      
      if nexp >= -1022 && nexp <= 1023  % cas général
        fprintf(1,'%s==  %s(2d^%+05dd)*1.%sb\n',rd,s,nexp,mantb);
      else % cas spéciaux
        if nexp==-1023 && all(mantb=='0')     % ZÉRO
          fprintf(1,'%s==  %sZÉRO\n',rd,s);
        elseif nexp==1024 && all(mantb=='0')  % INF
          fprintf(1,'%s==  %sINFINI\n',rd,s);
        elseif nexp==1024 && mantb(1)=='1'    % NaN (QNaN)
          fprintf(1,'%s==  NaN    (QNaN (%s)"%sh")\n',rd,s,dec2hex(bin2dec(mantb)));
        elseif nexp==1024 && mantb(1)=='0'    % NaN (SNaN)
          fprintf(1,'%s==  NaN    (SNaN (%s)"%sh")\n',rd,s,dec2hex(bin2dec(mantb)));
        elseif nexp==-1023 && any(mantb=='1') % nombre DÉNORMALISÉ
          fprintf(1,'%+s==  %s(2d^%+05dd)*0.%sb DÉNORMALISÉ\n',rd,s,-1022,mantb);
        else
          fprintf(1,'%s==  ????\n',rd);
        end
      end
   
      
    case 'single'  % IEEE 754
      
      expb=rb(2:9);
      nexp=bin2dec(expb)-127;
      mantb=rb(10:end);
      
      rd=sprintf('%+15.7E(décimal)',r); % la valeur décimale avec TOUS les chiffres

      
      if nexp >= -126 && nexp <= 127  % cas général
        fprintf(1,'%s==  %s(2d^%+04dd)*1.%sb                #binary32 "single float"\n',rd,s,nexp,mantb);
      else % cas spéciaux
        if nexp==-127 && all(mantb=='0')     % ZÉRO
          fprintf(1,'%s==  %sZÉRO                                                 #binary32 "single float"\n',rd,s);
        elseif nexp==128 && all(mantb=='0')  % INF
          fprintf(1,'%s==  %sINFINI                                               #binary32 "single float"\n',...
            rd,s);
        elseif nexp==128 && mantb(1)=='1'    % NaN (QNaN)
          fprintf(1,'%s==  NaN    (QNaN (%s)"%sh")                            #binary32 "single float"\n',...
            rd,s,dec2hex(bin2dec(mantb)));
        elseif nexp==128 && mantb(1)=='0'    % NaN (SNaN)
          fprintf(1,'%s==  NaN    (SNaN (%s)"%sh")                            #binary32 "single float"\n',...
            rd,s,dec2hex(bin2dec(mantb)));
        elseif nexp==-127 && any(mantb=='1') % nombre DÉNORMALISÉ
          fprintf(1,'%+s==  %s(2d^%+04dd)*0.%sb DÉNORMALISÉ    #binary32 "single float"\n',rd,s,-126,mantb);
        else
          fprintf(1,'%s==  ????\n',rd);
        end
      end

  end
  
else       % si  r  est tableau
  r=r(:)';
  L=length(r);
  r=r(1:min(20,end));
  for ri=r
    AffBin(ri) % Appel récursif
  end
  if L>20
    fprintf(2,'########## /!\\  SEULS LES 20 PREMIERS TERMES DU TABLEAU ONT ÉTÉ IMPRIMÉS... ##########\n');
    fprintf(2,'########## /!\\  ONLY THE FIRST 20 ARRAY ELEMENTS HAVE BEEN PRINTED...       ##########\n');
  end
end





