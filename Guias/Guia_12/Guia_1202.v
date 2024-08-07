/**
    821811
    Felipe Rivetti Mizher
    Questão 2:
*/

module jkff(output q, 
            output qnot,
            input j, 
            input k,
            input clk, 
            input preset, 
            input clear);

    reg q, qnot;
    always @(posedge clk or posedge preset or posedge clear)begin
        if(clear)begin
            q <= 0; qnot <= 1;
        end
        else if(preset)begin
            q <= 1;     
            qnot <= 0; 
        end
        else if(j & ~k)begin 
            q <= 1;
            qnot <= 0; 
        end
        else if(~j & k)begin 
            q <= 0; 
            qnot <= 1; 
        end
        else if(j & k)begin 
            q <= ~q; 
            qnot <= ~qnot; 
        end
    end
    
endmodule // end jkff

module memoria_RAM_1x8( input wire clk,          
                        input wire reset,       
                        input wire endereco,   
                        input wire [7:0] dado_in, 
                        output reg [7:0] dado_out);

    wire [7:0] q;
    wire [7:0] qnot;
    wire j, k;

    generate
        genvar i;
        for(i = 0; i < 8; i = i + 1)begin : jk_loop
            jkff jk_inst(
                .q(q[i]),
                .qnot(qnot[i]),
                .j(j),
                .k(k),
                .clk(clk),
                .preset(1'b0),
                .clear(1'b0));
        end
    endgenerate

    always @(posedge clk)begin
        if(reset)begin
            dado_out <= 8'b0;
        end else if(endereco)begin
            dado_out <= dado_in;
        end
    end

    always @(negedge clk)begin
        if(!reset && !endereco)begin
            dado_out <= dado_out;
        end
    end

endmodule // end memoria_RAM_1x8

module teste_memoria_RAM_1x8;

    parameter PERIOD = 10; 

    reg clk = 0;            
    reg reset = 1;          
    reg endereco = 0;      
    reg [7:0] dado_in = 0;  

    memoria_RAM_1x8 memoria_ram(
        .clk(clk),
        .reset(reset),
        .endereco(endereco),
        .dado_in(dado_in),
        .dado_out()
    );

    always #((PERIOD/2)) clk = ~clk;

    initial begin
        $display("Inicializando teste.");
        $display("Escrevendo na memória.");
        dado_in = 8'b10101010; 
        endereco = 1;           
        #20;                    
        $display("Lendo da memória.");
        endereco = 0;           
        #20;                   
        $display("Teste finalizado.");
        $finish;
    end

endmodule // end teste_memoria_RAM_1x8