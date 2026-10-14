local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir '/Users/leoncelamien/Documents/pass/Concepts_des_langages_de_programmation/Project'}
   % Dossier = {Property.condGet cwdir 'C:\\Users\Thomas\Documents\UCL\Oz\Projet'} % Windows example.
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   % The two function you have to implement
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % Width and height of the grid
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   % Please do NOT change this line.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here  %
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

   local
      % Fonctions
      NextAcc Reverse Move Turn DecodeInstruction Repeat DecodeStrategyACC Bonus BonusACC Wormhole Emb ElementNumber
   in

      /*
       * Compte le nombre d'effets
       *
       * @arg : Effects : liste des effets du vaisseau
       *        N : stocke le nombre d'effets
       * @ret : le nombre d'effets dans la liste
       */
      fun {ElementNumber Effects N}
         if Effects.2 == nil then
            N+1
         else
            {ElementNumber Effects.2 N+1}
         end
      end

      /* 
       * Inverse la liste du vaisseau et inverse les directions
       * 
       * @arg : L : liste des positions du vaisseau
       * @ret : nouvelle liste inversée et avec directions inversées
       */
      fun {Reverse L}
         fun {RevAcc L Acc} NewDirection NewPos in
            if L == nil then Acc
            else
               case L.1.to of
               north then NewDirection = south
               [] south then NewDirection = north
               [] east then NewDirection = west
               [] west then NewDirection = east
               end
               NewPos = pos(x:L.1.x y:L.1.y to:NewDirection)
               {RevAcc L.2 NewPos|Acc}
            end
         end
      in
         {RevAcc L nil}
      end

      /* 
       * Renvoi le dernier element d'une liste
       * 
       * @arg : Positions : liste des positions du vaisseau
       * @ret : dernier élément de la liste
       */
      fun {BonusACC Positions}
         if Positions.2 == nil then 
            Positions.1
         else
            {BonusACC Positions.2}
         end
      end

      /* 
       * Effet Wormhole
       * 
       * @arg : Positions : liste des positions du vaisseau
       *        L : liste contenant la nouvelle position de la tête du vaisseau
       * @ret : liste contenant les nouvelles positions du vaisseau
       */
      fun {Wormhole Positions L}
         if Positions.2 == nil then 
            L
         else
            {Wormhole Positions.2 {Append L [Positions.1]}}
         end
      end

      /* 
       * Effet EMB (ElectroMagnetic bomb)
       * 
       * @arg : Effects : liste des effets du vaisseau
       * @ret : soit liste contenant effet EMB avec le step mis à jour, soit liste avec nil soit nil
       */
      fun {Emb Effects}
         local A C in
            A = {BonusACC Effects}
            if A == nil then
               nil
            else
               C = A.1-1
               if C == 0 then
                  [nil]
               else
                  [emb(C)]
               end
            end
         end
      end

      /* 
       * Gestion des bonus de la carte
       * 
       * @arg : Positions : liste des positions du vaisseau
       *        Effects : liste des effets du vaisseau ou le premier effet de la liste
       *        B : liste contenant les nouvelles positions du vaisseau
       * @ret : liste de position
       */
      fun {Bonus Positions Effects B}
         if Effects.1 == scrap then
            {Append B [{BonusACC  Positions }]}
         elseif Effects.1 == revert then
            {Reverse Positions}
         elseif {Label Effects.1} == wormhole then
            {Wormhole Positions [pos(x:Effects.1.x y:Effects.1.y to:Positions.1.to)]}
         elseif {Label Effects.1} == emb then
            if {BonusACC Effects} == nil then
               B
            else
               Positions
            end
         elseif Effects.1 == emb then
            B
         else
            Positions
         end
      end

      /* 
       * Gestion des mouvements turn right et turn left
       * 
       * @arg : Spaceship : position d'une cellule (tête ou wagon) du vaisseau
       *        RelativeDirection : left|right
       * @ret : nouvelle position
       */
      fun {Turn Spaceship RelativeDirection}
         case Spaceship.to of
         north then
            case RelativeDirection of
            left then {Move Spaceship west}
            [] 
            right then {Move Spaceship east}
            else
               {Move Spaceship north}
            end
         [] 
         south then
            case RelativeDirection of
            left then {Move Spaceship east}
            [] 
            right then {Move Spaceship west}
            else
               {Move Spaceship south}
            end
         [] 
         west then
            case RelativeDirection of
            left then {Move Spaceship south}
            [] 
            right then {Move Spaceship north}
            else
               {Move Spaceship west}
            end
         [] 
         east then
            case RelativeDirection of
            left then {Move Spaceship north}
            [] 
            right then {Move Spaceship south}
            else
               {Move Spaceship east}
            end
         end
      end

      /* 
       * Avance de 1 le vaisseau en fonction de la direction
       * 
       * @arg : Spaceship : position d'une cellule (tête ou wagon) du vaisseau
       *        Direction : north|south|west|east
       * @ret : nouvelle position
       */
      fun {Move Spaceship Direction}
         case Direction of
         north then
            [pos(x:Spaceship.x y:Spaceship.y-1 to:Direction)]
         [] 
         south then
            [pos(x:Spaceship.x y:Spaceship.y+1 to:Direction)]
         [] 
         west then
            [pos(x:Spaceship.x-1 y:Spaceship.y to:Direction)]
         [] 
         east then
            [pos(x:Spaceship.x+1 y:Spaceship.y to:Direction)]
         end
      end

      /* 
       * Mise à jour des positions des wagons
       * 
       * @arg : Positions : liste de positiion sans le premier élément
       *        Instruction : forward | turn(left) | turn(right)
       *        L : nouvelle position de la tête
       *        PreviousPosition : l'ancienne position du vaisseau
       * @ret : liste des nouvelles positions du vaisseau 
       */ 
      fun {NextAcc Positions Instruction L PreviousPosition}
         if Positions.2 == nil then 
            {Append L [pos(x:PreviousPosition.x y:PreviousPosition.y to:PreviousPosition.to)]}
         else
            {NextAcc Positions.2 Instruction {Append L [pos(x:PreviousPosition.x y:PreviousPosition.y to: L.1.to)]} Positions.1}
         end
      end

      % La fonction qui renvoit les nouveaux attributs du serpent après prise
      % en compte des effets qui l'affectent et de son instruction
      % 
      % instruction ::= forward | turn(left) | turn(right)
      % P ::= <integer x such that 1 <= x <= 24>
      % direction ::= north | south | west | east
      % spaceship ::=  spaceship(
      %               positions: [
      %                  pos(x:<P> y:<P> to:<direction>) % Head
      %                  ...
      %                  pos(x:<P> y:<P> to:<direction>) % Tail
      %               ]
      %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
      %            )
      fun {Next Spaceship Instruction}  
         local A B in
            case Instruction of
            forward then
               B = {Move Spaceship.positions.1 Spaceship.positions.1.to}
            [] 
            turn(left) then
               B = {Turn Spaceship.positions.1 left}
            [] 
            turn(right) then
               B = {Turn Spaceship.positions.1 right}
            end
            if Spaceship.positions.2 == nil then
               if Spaceship.effects \= nil then
                  spaceship(positions: {Bonus Spaceship.positions Spaceship.effects.1 B} effects: Spaceship.effects.2) 
               else
                  spaceship(positions:B effects: Spaceship.effects)  
               end
            else
               A = {NextAcc Spaceship.positions.2 Instruction B Spaceship.positions.1}
               if  Spaceship.effects \= nil then
                  if {Label Spaceship.effects.1} == wormhole then
                        if {ElementNumber Spaceship.effects 0} mod 2 == 1 then
                           spaceship(positions: {Bonus Spaceship.positions Spaceship.effects A} effects: Spaceship.effects)
                        else
                           spaceship(positions:A effects: nil) 
                        end
                  elseif {Label Spaceship.effects.1} == emb then
                     spaceship(positions:{Bonus Spaceship.positions Spaceship.effects A} effects: {Emb Spaceship.effects}) 
                  elseif Spaceship.effects.1 == ghost then
                     spaceship(positions:A effects: Spaceship.effects) 
                  elseif Spaceship.effects.1 == dropSeismicCharge then
                        spaceship(positions:A effects: Spaceship.effects.2 seismicCharge:true|Spaceship.seismicCharge)
                  else
                     spaceship(positions: {Bonus Spaceship.positions Spaceship.effects A} effects: Spaceship.effects.2)
                  end
               else
                  spaceship(positions:A effects: Spaceship.effects) 
               end
            end
         end
      end

      /* 
       * Decode l'instruction
       * 
       * @arg : Instruction : forward | turn(left) | turn(right)
       * @ret : liste de fonction Next
       */ 
      fun {DecodeInstruction Instruction}
         case Instruction of
         forward then
            [fun {$ Spaceship} {Next Spaceship forward} end]
         [] 
         turn(left) then
            [fun {$ Spaceship} {Next Spaceship turn(left)} end]
         [] 
         turn(right) then
            [fun {$ Spaceship} {Next Spaceship turn(right)} end]
         end
      end

      /* 
       * @arg : Strategy : forward | turn(left) | turn(right)
       *        Times : nombre de fois
       *        L : position de la tête
       * @ret : liste contenant l'instruction réalisée N fois
       */ 
      fun {Repeat Strategy Times L}
         if Times == 0 then 
            L
         else 
            {Repeat Strategy Times-1 {Append L {DecodeInstruction Strategy}}}
         end
      end

      /* 
       * @arg : Strategy : liste d'instruction
       *        L : liste des instructions sauf le premier éléments
       * @ret : nouvelle liste strategie et de positions
       */ 
      fun {DecodeStrategyACC Strategy L}
         if Strategy.2 == nil then 
            case Strategy.1 of
            forward then
               {Append L {DecodeInstruction forward}}
            [] 
            turn(left) then
               {Append L {DecodeInstruction turn(left)}}
            [] 
            turn(right) then
               {Append L {DecodeInstruction turn(right)}}
            else
               {Repeat Strategy.1.1.1  Strategy.1.times L}
            end
         else    
            case Strategy.1 of
            forward then
               {DecodeStrategyACC Strategy.2  {Append L {DecodeInstruction forward}}}
            [] 
            turn(left) then
               {DecodeStrategyACC Strategy.2  {Append L {DecodeInstruction turn(left)}}}
            [] 
            turn(right) then
               {DecodeStrategyACC Strategy.2  {Append L {DecodeInstruction turn(right)}}}
            else
               {Repeat Strategy.1.1.1  Strategy.1.times L}
            end
         end
      end

      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {DecodeStrategy Strategy}
         if Strategy == nil then
            nil
         else
            local B in
               case Strategy.1 of
                  forward then
                     B = {DecodeInstruction forward}
                  [] 
                  turn(left) then
                     B = {DecodeInstruction turn(left)}
                  [] 
                  turn(right) then
                     B = {DecodeInstruction turn(right)}
               else
                  B = {Repeat Strategy.1.1.1  Strategy.1.times [nil]}.2
               end
               if Strategy.2 == nil then
                  B
               else
                  {DecodeStrategyACC Strategy.2 B}
               end
            end
         end
      end

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/Scenario.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 5
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end