dtmc

module Distributeur

// Définition des propositions atomiques
	// PA Waiting
	wait : bool init true; // Est-ce que on attend une action de l'utilisateur ?
	
	// PA Buttons
	B_caf : bool init false; // est-ce que le bouton café a été pressé ?
	B_the : bool init false; // est-ce que le bouton thé a été pressé ?
	B_ann : bool init false; // est-ce que le bouton annulé a été pressé ?
	B_suc : bool init false; // est-ce que le bouton sucre a été pressé ?
	
	// PA Voyants
	// Prevoir un voyant pour le cas d'erreur ? Pas la meilleur representation
	// Voy = 0 : Le voyant "prêt" est allumé
	// Voy = 1 : Le voyant "preparation "est allumé
	// Voy = 2 : Le voyant "fin" est allumé

	Voy   : [0..2] init 0;
	
	//PA Pièce
	P_50  : bool init false; // est-ce que la pièce vient d'être inserée ?
	R_50  : bool init false; // est-ce que la pièce vient d'être rendue ?
	
	//PA Utilisateur
	G_out : bool init false; // est-ce que l'utilisateur vient de prendre son gobelet ?

	// PA Sucre
	// P_suc = 0 : il n'y a pas de sucre
	// P_suc = 1 : il y a du sucre en quantité moyenne
	// P_suc = 2 : il y a beaucoup de sucre
	P_suc : [0..2] init 0;

	// PA Mode
	// Mode = 0 : Le distributeur est en mode "dispo" - label "M_dispo"
	// Mode = 1 : Le distributeur est en mode "choix" - label "M_choix"
	// Mode = 2 : Le distributeur est en mode "prepa" - label "M_prepa"
	// Mode = 3 : Le distributeur est en mode "fin"   - label "M_fin"
	Mode : [0..3] init 0;
	
	// PA Type
	// Type = 0 : L'utilisateur n'a rien selectionné
	// Type = 1 : L'utilisateur a selectionné du café
	// Type = 2 : L'utilisateur a selectionné du thé
	Type : [0..2] init 0;

	// PA Preparation
	// Prepa = 0 : La distributeur n'a rien préparé
	// Prepa = 1 : La distributeur a préparé du café
	// Prepa = 2 : La distributeur a préparé du the
	Prepa : [0..2] init 0;
	
	[] Mode= 0 & wait -> (P_50' = true) & (wait' = false);
	[] Mode= 0 & P_50 & !wait-> (Mode' = 1) & (P_50'= false) & (wait' = true);
	
	[] Mode= 1 & wait -> (Mode'= 0) & (B_ann' = true) & (R_50'= true) & (P_suc' = 0) & (wait' = false);
	[] Mode= 0 & !wait & B_ann -> (B_ann' = false) & (R_50'= false) & (wait'= true);
	
	[] Mode= 1 & wait -> (B_suc' = true) & (wait' = false);
	[] Mode= 1 & !wait & B_suc & (P_suc = 0) -> (P_suc' = 1) & (B_suc' = false) & (wait'= true);
	[] Mode= 1 & !wait & B_suc & (P_suc = 1) -> (P_suc' = 2) & (B_suc' = false) & (wait'= true);
	[] Mode= 1 & !wait & B_suc & (P_suc = 2) -> (P_suc' = 0) & (B_suc' = false) & (wait'= true);

	[] Mode= 1 & wait -> (B_caf' = true) & (wait'= false);
	[] Mode= 1 & wait -> (B_the' = true) & (wait'= false);
	[] Mode= 1 & !wait & B_caf -> (Mode'= 2) & (Voy' = 1) & (B_caf'= false) & (Type'= 1) & (wait'= false);
	[] Mode= 1 & !wait & B_the -> (Mode'= 2) & (Voy' = 1) & (B_the'= false) & (Type'= 2) & (wait'= false);
 
	[] Mode= 2 & Type= 1 & !wait -> (Mode'= 3) & (Voy' = 2) & (Prepa' = 1) & (wait'= true);
	[] Mode= 2 & Type= 2 & !wait -> (Mode'= 3) & (Voy' = 2) & (Prepa' = 2) & (wait'= true);

	[] Mode= 3 & wait & !G_out -> (G_out'= true) & (Type'= 0) & (P_suc'= 0) & (Prepa'= 0);
	[] Mode= 3 & G_out -> (Mode'= 0) & (Voy'= 0) & (G_out'= false);

//Distribuer une petite touilette si il y a du sucre ==> Cela se fait facilement avec cette implémentation
// Remarque : La machine ne peut pas préparer deux types de boissons en parallèle d'où cette implémentation.

// Définition des transitions
	
endmodule

// Définition des labels

// Voir PA Sucre
label "P_pas_sucre"  = (P_suc = 0);
label "P_sucre"      = (P_suc = 1);
label "P_tres_sucre" = (P_suc = 2);

// Voir PA Mode
label "M_dispo" = (Mode = 0);
label "M_choix" = (Mode = 1);
label "M_prepa" = (Mode = 2);
label "M_fin"   = (Mode = 3);

// Voir PA Type
label "T_caf"  = (Type = 1);
label "T_the"  = (Type = 2);


// Voir rapport pour plus de détails
label "P_cafe" = (Mode = 3 & Type = 1);
label "P_the"  = (Mode = 3 & Type = 2);


// Labels des booleans
label "V_rdy" = (Voy = 0);
label "V_prp" = (Voy = 1);
label "V_fin" = (Voy = 2);

label "P_50" = P_50;
label "R_50" = R_50;

label "G_out" = G_out;
label "B_the" = B_the;
label "B_caf" = B_caf;
label "B_ann" = B_ann;
label "B_suc" = B_suc;
