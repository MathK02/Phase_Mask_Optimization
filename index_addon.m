function n=index_addon(lambda)
% entrée : lambda : longueur d'onde en um
% sortie : indices des deux verres pour ces longueurs d'onde

B=[1.34317774 0.241144399 9.94317969*10^(-1); 1.39757037 0.159201403 1.2686543];
C=[7.04687339*10^(-3) 2.29005*10^(-2) 9.27508256*10;9.95906143*10^(-3) 5.46931752*10^(-2) 1.19248346*100];


% pour la longueur d'onde de ref

n2(1,:)=1-B(1,1)*lambda.^2./(C(1,1)-lambda.^2)-B(1,2)*lambda.^2./(C(1,2)-lambda.^2)-B(1,3)*lambda.^2./(C(1,3)-lambda.^2);
n2(2,:)=1-B(2,1)*lambda.^2./(C(2,1)-lambda.^2)-B(2,2)*lambda.^2./(C(2,2)-lambda.^2)-B(2,3)*lambda.^2./(C(2,3)-lambda.^2);

n=sqrt(n2);
