module cla16(A,B,Cin,S,Cout);

    // Author: Adam Nygard

    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [2:0] Cout_in;

    cla4 cla4_1(.A(A[3:0]),.B(B[3:0]),.Cin(Cin),.S(S[3:0]),.Cout(Cout_in[0]));
    cla4 cla4_2(.A(A[7:4]),.B(B[7:4]),.Cin(Cout_in[0]),.S(S[7:4]),.Cout(Cout_in[1]));
    cla4 cla4_3(.A(A[11:8]),.B(B[11:8]),.Cin(Cout_in[1]),.S(S[11:8]),.Cout(Cout_in[2]));
    cla4 cla4_4(.A(A[15:12]),.B(B[15:12]),.Cin(Cout_in[2]),.S(S[15:12]),.Cout(Cout));

endmodule