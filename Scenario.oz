local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:green name:steve
			   positions: [pos(x:11 y:12 to:east) pos(x:10 y:12 to:east)]
			   effects: nil
			   strategy: [forward turn(left) forward forward forward forward forward forward forward forward turn(left) forward forward forward forward forward forward
			   turn(left) forward forward forward forward forward forward forward turn(left) forward forward forward forward forward forward forward forward turn(right)
			   turn(left) forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward forward]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:red name:patrick
			   positions: [pos(x:7 y:10 to:north) pos(x:7 y:11 to:north)]
			   effects: nil
			   strategy: [forward forward forward forward forward forward forward forward forward forward forward forward forward turn(right) turn(right) forward forward turn(right) forward  turn(right) forward forward forward forward forward turn(right) forward forward forward forward forward forward 
			   turn(right) forward turn(right) forward forward forward forward forward forward forward turn(left) forward forward forward forward forward turn(left) forward forward turn(left) forward forward forward forward turn(right) turn(left)
			   forward forward forward forward forward forward forward forward turn(right) forward forward forward forward forward forward forward forward]
			   seismicCharge: NoBomb
			  )
		    ]
	    bonuses: [
		    bonus(position:pos(x:7 y:15)  color:orange effect:wormhole(x:14 y:13) target:catcher)
		    bonus(position:pos(x:14 y:13)  color:orange effect:wormhole(x:7 y:15) target:catcher)
		    bonus(position:pos(x:7 y:8)   color:yellow effect:wormhole(x:7 y:16) target:catcher)
		    bonus(position:pos(x:7 y:16)  color:yellow effect:wormhole(x:7 y:8) target:catcher)
			bonus(position:pos(x:18 y:18)  color:purple effect:wormhole(x:14 y:11) target:catcher)
		    bonus(position:pos(x:14 y:11)  color:purple effect:wormhole(x:18 y:18) target:catcher)

			bonus(position:pos(x:14 y:12)  color:maroon effect:ghost target:catcher)
			bonus(position:pos(x:5 y:10)  color:maroon effect:ghost target:catcher)

			bonus(position:pos(x:7 y:9)  color:blue effect:dropSeismicCharge target:catcher)
			bonus(position:pos(x:5 y:9)  color:blue effect:dropSeismicCharge target:catcher)

			bonus(position:pos(x:14 y:10)  color:green effect:emb(2) target:catcher)
			bonus(position:pos(x:12 y:8)  color:green effect:emb(2) target:catcher)

			bonus(position:pos(x:10 y:14) color:red effect:revert target:catcher)
			bonus(position:pos(x:16 y:14) color:red effect:revert target:catcher)

			bonus(position:pos(x:14 y:9) color:grey effect:scrap target:catcher)
			bonus(position:pos(x:12 y:7) color:grey effect:scrap target:catcher)
			bonus(position:pos(x:19 y:7) color:grey effect:scrap target:catcher)
			bonus(position:pos(x:15 y:14) color:grey effect:scrap target:catcher)
			bonus(position:pos(x:10 y:10) color:grey effect:scrap target:catcher)

	    ]
	    bombs:nil
	   )
end