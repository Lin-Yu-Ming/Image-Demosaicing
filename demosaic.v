module demosaic(clk, reset, in_en, data_in, wr_r, addr_r, wdata_r, rdata_r, wr_g, addr_g, wdata_g, rdata_g, wr_b, addr_b, wdata_b, rdata_b, done);
input clk;
input reset;
input in_en;
input [7:0] data_in;
output reg wr_r;
output reg [13:0] addr_r;
output reg [10:0] wdata_r;
input [7:0] rdata_r;
output reg wr_g;
output reg [13:0] addr_g;
output reg [10:0] wdata_g;
input [7:0] rdata_g;
output reg wr_b;
output reg [13:0] addr_b;
output reg [10:0] wdata_b;
input [7:0] rdata_b;
output reg done;



reg[15:0] colum,row,position,red1,red2,red3,red4,red5,red6,colum1,
          blue1,blue2,blue3,blue4,blue5,blue6,
			 green1,green2,green3,green4,green5,green6;
reg[8:0] count,count1,a,b,c,d,e,state,n_state;

parameter INIT=6'd0,COLUM_STATE=6'd1,ROW_STATE=6'd2,CALCULATE_A_B=6'd3,
          CALCULATE_C_D=6'd4,CHECK=6'd5;
			 
			 

always @(posedge clk or posedge reset) 
begin
    if(reset) 
	   state = INIT;
	 else 
	   state = n_state;
end


always@(*)
begin
    case(state)  
      INIT:begin
		  n_state=COLUM_STATE;
		end
		
		COLUM_STATE:begin
		  if(colum>16383)
		    n_state=CALCULATE_A_B;
		  else
		    n_state=(count > 8'd126)?ROW_STATE:COLUM_STATE;
		end
		
		ROW_STATE:begin
		  if(colum>16383)
		    n_state=CALCULATE_A_B;
			 
		  else
		    n_state=(count > 8'd126)?COLUM_STATE:ROW_STATE;	
		end
		
		CALCULATE_A_B:begin
		  if(colum1>16254)
		    n_state=CHECK;
		  else
		    n_state=(count1>8'd125)?CALCULATE_C_D:CALCULATE_A_B;		
		end
		
		CALCULATE_C_D:begin
		  if(colum1>16254)
		    n_state=CHECK;
		  else
		    n_state=(count1>8'd125)?CALCULATE_A_B:CALCULATE_C_D;		
		
		end
		
		CHECK:begin
		  n_state=INIT;	
		end
		
		default:begin
		  n_state=INIT;	
		end 
	 endcase
end

always@(posedge clk)
begin

		  case(state)
		    INIT:begin
			   done<=0;
		      colum<=0;
				colum1<=129;
		      row<=0;
		      count<=0;
				count1<=0;
		      position<=0;
	         red1<=0;
				red2<=0;
				red3<=0;
				red4<=0;
				red5<=0;
				red6<=0;
				blue1<=0;
				blue2<=0;
				blue3<=0;
				blue4<=0;
				blue5<=0;
				blue6<=0;
				green1<=0;
				green2<=0;
				green3<=0;
				green4<=0;
				green5<=0;
				green6<=0;
            a<=0;
				b<=0;
				c<=0;
				d<=0;
				e<=0;
				wr_r<=0;
				wr_g<=0;
            wr_b<=0;				
			 end
			 
			 COLUM_STATE:begin
			   
			       if(colum%2==0)
				      begin
				        wr_g<=1;
						  wr_r<=0;
						  wr_b<=0; 
					     addr_g<=position;
					     position<=position+1;
					     wdata_g<=data_in;
					     colum<=colum+1;
						  if(count==127) count <= 0;
						  else count <=count +1;
					     
				      end
				    else
				      begin
					     
					     if(count==127) begin
						      count <= 0;
								wr_g<=1;
						      wr_r<=0;
						      wr_b<=0; 
					         addr_g<=position;
					         position<=position+1;
					         wdata_g<=data_in;
					         colum<=colum+1;
						  end
						  else begin 
						      count <=count +1;
								wr_r<=1;
						      wr_g<=0;
						      wr_b<=0;
					         addr_r<=position;
					         position<=position+1;
					         wdata_r<=data_in;
					         colum<=colum+1;
		              end				  
					   end
		  
			  end
			  
			  ROW_STATE:begin
			       if(colum%2==0)
				      begin
				        wr_b<=1;
						  wr_g<=0;
						  wr_r<=0;
					     addr_b<=position;
					     position<=position+1;
					     wdata_b<=data_in;
					     colum<=colum+1;
					     
						  if(count==127) count <= 0;
						  else count <=count +1;
				      end
				    else
				      begin
					     if(count==127) begin
						      count <= 0;
								wr_g<=0;
						      wr_b<=0;
	                     wr_r<=1;
					         addr_r<=position;
					         position<=position+1;
					         wdata_r<=data_in;
					         colum<=colum+1;
						  end
						  else begin
						      count <=count +1;
								wr_g<=1;
						      wr_b<=0;
	                     wr_r<=0;
					         addr_g<=position;
					         position<=position+1;
					         wdata_g<=data_in;
					         colum<=colum+1;
	                 end							
					   end		   	  			 			  
			  end
			  
			  CALCULATE_A_B:begin

			  
			    if(count1>125)
				   begin
					  colum1<=colum1+2;
					  count1<=0;
					  wr_b<=0;
					  wr_r<=0;					  
					  wr_g<=0;
	              red1<=0;
				     red2<=0;
				     red3<=0;
				     red4<=0;
				     red5<=0;
				     red6<=0;
				     blue1<=0;
				     blue2<=0;
				     blue3<=0;
				     blue4<=0;
				     blue5<=0;
				     blue6<=0;
				     green1<=0;
				     green2<=0;
				     green3<=0;
				     green4<=0;
				     green5<=0;
				     green6<=0;					  
					end
       		 else			
		         begin	    
			        if(colum1%2==1)
				       begin
					      if(a==3)
					        begin
					          wr_b<=1;
					          wr_r<=1;
					          red1<=0;
					          red2<=0;
					          blue1<=0;
					          blue2<=0;
					          addr_b<=colum1;
					          addr_r<=colum1;
					          wdata_b<=(blue1+blue2)>>1;
					          wdata_r<=(red1+red2)>>1;
					          colum1<=colum1+1;
							    count1<=count1+1;
								 a<=0;
					        end
						 
					      else
					       begin
						      wr_b<=0;
					         wr_r<=0;
								wr_g<=0;
						        if(a==0)
							       begin
							         a<=a+1;
								      addr_b<=colum1-1;								      	
								      addr_r<=colum1-128;
								     						  
							       end
							  
							     else if(a==1)
							       begin
									   red1<=rdata_r;
										blue1<=rdata_b;
							         a<=a+1;
								      addr_b<=colum1+1;

								      addr_r<=colum1+128; 							   
							       end
									else
									  begin
									    a<=a+1;  
									    red2<=rdata_r;
										 blue2<=rdata_b;
									 end
						     end
					    end
					
					    else
						   begin
					        if(b==4)
						       begin
					            wr_r<=1;
                           wr_g<=1;
							      red3<=0;
							      red4<=0;
							      red5<=0;
							      red6<=0;
							      green3<=0;
							      green4<=0;
							      green5<=0;
							      green6<=0;
							      addr_r<=colum1;
							      addr_g<=colum1;
							      wdata_r<=(red3+red4+red5+red6)>>2;
							      wdata_g<=(green3+green4+green5+green6)>>2;
							      count1<=count1+1;
							      colum1<=colum1+1;
									b<=0;
							    end
							
						     else
						       begin
					            wr_r<=0;
                           wr_g<=0;
									wr_b<=0;
							      if(b==0)
							        begin
                               addr_g<=colum1-128;
								       addr_r<=colum1-129;
								       
								       										
								       b<=b+1;
								     end
							      else if(b==1)
							        begin
                               addr_g<=colum1-1;
								       addr_r<=colum1-127;
								       red3<=rdata_r;
								       green3<=rdata_g;										
								       b<=b+1;								 
								     end	 
							      else if(b==2)
							        begin
                               addr_g<=colum1+1;
								       addr_r<=colum1+127;
								       red4<=rdata_r;
								       green4<=rdata_g;										
								       b<=b+1;									 
								     end
							      else if(b==3)
							        begin
                               addr_g<=colum1+128;
								       addr_r<=colum1+129;
								       red5<=rdata_r;
								       green5<=rdata_g;										
								       b<=b+1;								 						 
								     end
									else
									  begin
									    b<=b+1;
										 green6<=rdata_g;
									    red6<=rdata_r;
									  end
									
									
									
							  end   
					   end
			    	end		
			    end
			     
				  CALCULATE_C_D:begin
				    if(count1>125)
					   begin
					     colum1<=colum1+2;
					     count1<=0;
					     wr_b<=0;
					     wr_r<=0;					  
					     wr_b<=0;
	                 red1<=0;
				        red2<=0;
				        red3<=0;
				        red4<=0;
				        red5<=0;
				        red6<=0;
				        blue1<=0;
				        blue2<=0;
				        blue3<=0;
				        blue4<=0;
				        blue5<=0;
				        blue6<=0;
				        green1<=0;
				        green2<=0;
				        green3<=0;
				        green4<=0;
				        green5<=0;
				        green6<=0;							
						end
						
					 else
					   begin
						  if(colum1%2==1)
						    begin
							   if(c==5)
								  begin
								    wr_g<=1;
								    wr_b<=1;
				                blue3<=0;
									 blue4<=0;
									 blue5<=0;
									 blue6<=0;
				                green3<=0;
									 green4<=0;
									 green5<=0;
									 green6<=0;
                            addr_g<=colum1;
                            addr_b<=colum1;
								    wdata_g<=(green3+green4+green5+green6)>>2;
								    wdata_b<=(blue3+blue4+blue5+blue6)>>2;
								    colum1<=colum1+1;
								    count1<=count1+1;  
									 c<=0;
								  end
								else
								  begin
								    wr_g<=0;
								    wr_b<=0;
								    wr_r<=0;
								    if(c==0)
									   begin
										  c<=c+1;
										  addr_g<=colum1-128;
										  addr_b<=colum1-129;
										  
										  
										end
									 else if(c==1)
									   begin
										  c<=c+1;
										  addr_g<=colum1-1;
										  addr_b<=colum1-127;
										  green3<=rdata_g;
  									     blue3<=rdata_b;										  												
										end
									 else if(c==2)
									   begin
										  c<=c+1;
										  addr_g<=colum1+1;
										  addr_b<=colum1+127;
										  green4<=rdata_g;
  									     blue4<=rdata_b;										  			
										end
									 else if(c==3)
									   begin
									     c<=c+1;
										  addr_g<=colum1+128;
										  addr_b<=colum1+129;
										  blue5<=rdata_b;
  									     green5<=rdata_g;											  		  
									   end 
										
									else
									  begin
									    c<=c+1; 
										 blue6<=rdata_b;
										 green6<=rdata_g;
									  end
								  end
							 end
						  else
						    begin
							   if(d==3)
								  begin
								    wr_r<=1;
								    wr_b<=1;
				                blue1<=0;
									 blue2<=0;
				                red1<=0;
									 red2<=0;
                            addr_r<=colum1;
                            addr_b<=colum1;
								    wdata_r<=(red1+red2)>>1;
								    wdata_b<=(blue1+blue2)>>1;
								    colum1<=colum1+1;
								    count1<=count1+1; 
									 d<=0;
								  end
								else
								  begin
								    wr_r<=0;
									 wr_b<=0;
									 wr_g<=0;
									 if(d==0)
									   begin
										  d<=d+1;
										  addr_b<=colum1-128;
										  addr_r<=colum1-1;
										  
										  
										end
									 else if(d==1)
									   begin
										  d<=d+1;
										  addr_b<=colum1+128;
										  addr_r<=colum1+1;
										  red1<=rdata_r;
										  blue1<=rdata_b;									  	
										end
							       else 
									   begin
										  d<=d+1;
										  blue2<=rdata_b;
										  red2<=rdata_r;	
										end
								  end
							 end		   
					   end	
				  end
				  
				  
				  
				  
				  CHECK:begin
				    done<=1;  
				  end
				  		
		 endcase
	 
 end
endmodule
