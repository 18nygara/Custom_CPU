module cla4(A,B,Cin,S,Cout);

    // Author: Adam Nygard

    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G, P;
    wire [2:0] Cout_in;

    // CLA block
    assign G = A & B;
    assign P = A | B;
    assign Cout_in[0] = G[0] | (P[0] & Cin); // used blocking assignments so 
                                             // the next statement is correct
    assign Cout_in[1] = G[1] | (P[1] & Cout_in[0]);
    assign Cout_in[2] = G[2] | (P[2] & Cout_in[1]);
    assign Cout = G[3] | (P[3] & Cout_in[2]);

    // S logic
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ Cout_in[0];
    assign S[2] = A[2] ^ B[2] ^ Cout_in[1];
    assign S[3] = A[3] ^ B[3] ^ Cout_in[2];

endmodule