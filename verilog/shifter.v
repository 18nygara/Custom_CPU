module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;
   wire [15:0] In_1, In_2, In_4;

   assign In_1[15] = Op[1] ? (Cnt[0] ? (Op[0] ? 1'b0 : In[0]) : In[15]) : (Cnt[0] ? In[14] : In[15]);
   assign In_1[14] = Op[1] ? (Cnt[0] ? In[15] : In[14]) : (Cnt[0] ? In[13] : In[14]);
   assign In_1[13] = Op[1] ? (Cnt[0] ? In[14] : In[13]) : (Cnt[0] ? In[12] : In[13]);
   assign In_1[12] = Op[1] ? (Cnt[0] ? In[13] : In[12]) : (Cnt[0] ? In[11] : In[12]);
   assign In_1[11] = Op[1] ? (Cnt[0] ? In[12] : In[11]) : (Cnt[0] ? In[10] : In[11]);
   assign In_1[10] = Op[1] ? (Cnt[0] ? In[11] : In[10]) : (Cnt[0] ? In[9] : In[10]);
   assign In_1[9] = Op[1] ? (Cnt[0] ? In[10] : In[9]) : (Cnt[0] ? In[8] : In[9]);
   assign In_1[8] = Op[1] ? (Cnt[0] ? In[9] : In[8]) : (Cnt[0] ? In[7] : In[8]);
   assign In_1[7] = Op[1] ? (Cnt[0] ? In[8] : In[7]) : (Cnt[0] ? In[6] : In[7]);
   assign In_1[6] = Op[1] ? (Cnt[0] ? In[7] : In[6]) : (Cnt[0] ? In[5] : In[6]);
   assign In_1[5] = Op[1] ? (Cnt[0] ? In[6] : In[5]) : (Cnt[0] ? In[4] : In[5]);
   assign In_1[4] = Op[1] ? (Cnt[0] ? In[5] : In[4]) : (Cnt[0] ? In[3] : In[4]);
   assign In_1[3] = Op[1] ? (Cnt[0] ? In[4] : In[3]) : (Cnt[0] ? In[2] : In[3]);
   assign In_1[2] = Op[1] ? (Cnt[0] ? In[3] : In[2]) : (Cnt[0] ? In[1] : In[2]);
   assign In_1[1] = Op[1] ? (Cnt[0] ? In[2] : In[1]) : (Cnt[0] ? In[0] : In[1]);
   assign In_1[0] = Op[1] ? (Cnt[0] ? In[1] : In[0]) : (Cnt[0] ? (Op[0] ? 0 : In[15]) : In[0]);

   // shift by 2
   assign In_2[15] = Op[1] ? (Cnt[1] ? (Op[0] ? 1'b0 : In_1[1]) : In_1[15]) : (Cnt[1] ? In_1[13] : In_1[15]);
   assign In_2[14] = Op[1] ? (Cnt[1] ? (Op[0] ? 1'b0 : In_1[0]) : In_1[14]) : (Cnt[1] ? In_1[12] : In_1[14]);
   assign In_2[13] = Op[1] ? (Cnt[1] ? In_1[15] : In_1[13]) : (Cnt[1] ? In_1[11] : In_1[13]);
   assign In_2[12] = Op[1] ? (Cnt[1] ? In_1[14] : In_1[12]) : (Cnt[1] ? In_1[10] : In_1[12]);
   assign In_2[11] = Op[1] ? (Cnt[1] ? In_1[13] : In_1[11]) : (Cnt[1] ? In_1[9] : In_1[11]);
   assign In_2[10] = Op[1] ? (Cnt[1] ? In_1[12] : In_1[10]) : (Cnt[1] ? In_1[8] : In_1[10]);
   assign In_2[9] = Op[1] ? (Cnt[1] ? In_1[11] : In_1[9]) : (Cnt[1] ? In_1[7] : In_1[9]);
   assign In_2[8] = Op[1] ? (Cnt[1] ? In_1[10] : In_1[8]) : (Cnt[1] ? In_1[6] : In_1[8]);
   assign In_2[7] = Op[1] ? (Cnt[1] ? In_1[9] : In_1[7]) : (Cnt[1] ? In_1[5] : In_1[7]);
   assign In_2[6] = Op[1] ? (Cnt[1] ? In_1[8] : In_1[6]) : (Cnt[1] ? In_1[4] : In_1[6]);
   assign In_2[5] = Op[1] ? (Cnt[1] ? In_1[7] : In_1[5]) : (Cnt[1] ? In_1[3] : In_1[5]);
   assign In_2[4] = Op[1] ? (Cnt[1] ? In_1[6] : In_1[4]) : (Cnt[1] ? In_1[2] : In_1[4]);
   assign In_2[3] = Op[1] ? (Cnt[1] ? In_1[5] : In_1[3]) : (Cnt[1] ? In_1[1] : In_1[3]);
   assign In_2[2] = Op[1] ? (Cnt[1] ? In_1[4] : In_1[2]) : (Cnt[1] ? In_1[0] : In_1[2]);
   assign In_2[1] = Op[1] ? (Cnt[1] ? In_1[3] : In_1[1]) : (Cnt[1] ? (Op[0] ? 0 : In_1[15]) : In_1[1]);
   assign In_2[0] = Op[1] ? (Cnt[1] ? In_1[2] : In_1[0]) : (Cnt[1] ? (Op[0] ? 0 : In_1[14]) : In_1[0]);

   // shift by 4
   assign In_4[15] = Op[1] ? (Cnt[2] ? (Op[0] ? 1'b0 : In_2[3]) : In_2[15]) : (Cnt[2] ? In_2[11] : In_2[15]);
   assign In_4[14] = Op[1] ? (Cnt[2] ? (Op[0] ? 1'b0 : In_2[2]) : In_2[14]) : (Cnt[2] ? In_2[10] : In_2[14]);
   assign In_4[13] = Op[1] ? (Cnt[2] ? (Op[0] ? 1'b0 : In_2[1]) : In_2[13]) : (Cnt[2] ? In_2[9] : In_2[13]);
   assign In_4[12] = Op[1] ? (Cnt[2] ? (Op[0] ? 1'b0 : In_2[0]) : In_2[12]) : (Cnt[2] ? In_2[8] : In_2[12]);
   assign In_4[11] = Op[1] ? (Cnt[2] ? In_2[15] : In_2[11]) : (Cnt[2] ? In_2[7] : In_2[11]);
   assign In_4[10] = Op[1] ? (Cnt[2] ? In_2[14] : In_2[10]) : (Cnt[2] ? In_2[6] : In_2[10]);
   assign In_4[9] = Op[1] ? (Cnt[2] ? In_2[13] : In_2[9]) : (Cnt[2] ? In_2[5] : In_2[9]);
   assign In_4[8] = Op[1] ? (Cnt[2] ? In_2[12] : In_2[8]) : (Cnt[2] ? In_2[4] : In_2[8]);
   assign In_4[7] = Op[1] ? (Cnt[2] ? In_2[11] : In_2[7]) : (Cnt[2] ? In_2[3] : In_2[7]);
   assign In_4[6] = Op[1] ? (Cnt[2] ? In_2[10] : In_2[6]) : (Cnt[2] ? In_2[2] : In_2[6]);
   assign In_4[5] = Op[1] ? (Cnt[2] ? In_2[9] : In_2[5]) : (Cnt[2] ? In_2[1] : In_2[5]);
   assign In_4[4] = Op[1] ? (Cnt[2] ? In_2[8] : In_2[4]) : (Cnt[2] ? In_2[0] : In_2[4]);
   assign In_4[3] = Op[1] ? (Cnt[2] ? In_2[7] : In_2[3]) : (Cnt[2] ? (Op[0] ? 0 : In_2[15]) : In_2[3]);
   assign In_4[2] = Op[1] ? (Cnt[2] ? In_2[6] : In_2[2]) : (Cnt[2] ? (Op[0] ? 0 : In_2[14]) : In_2[2]);
   assign In_4[1] = Op[1] ? (Cnt[2] ? In_2[5] : In_2[1]) : (Cnt[2] ? (Op[0] ? 0 : In_2[13]) : In_2[1]);
   assign In_4[0] = Op[1] ? (Cnt[2] ? In_2[4] : In_2[0]) : (Cnt[2] ? (Op[0] ? 0 : In_2[12]) : In_2[0]);

   // shift by 8
   assign Out[15] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[7]) : In_4[15]) : (Cnt[3] ? In_4[7] : In_4[15]);
   assign Out[14] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[6]) : In_4[14]) : (Cnt[3] ? In_4[6] : In_4[14]);
   assign Out[13] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[5]) : In_4[13]) : (Cnt[3] ? In_4[5] : In_4[13]);
   assign Out[12] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[4]) : In_4[12]) : (Cnt[3] ? In_4[4] : In_4[12]);
   assign Out[11] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[3]) : In_4[11]) : (Cnt[3] ? In_4[3] : In_4[11]);
   assign Out[10] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[2]) : In_4[10]) : (Cnt[3] ? In_4[2] : In_4[10]);
   assign Out[9] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[1]) : In_4[9]) : (Cnt[3] ? In_4[1] : In_4[9]);
   assign Out[8] = Op[1] ? (Cnt[3] ? (Op[0] ? 1'b0 : In_4[0]) : In_4[8]) : (Cnt[3] ? In_4[0] : In_4[8]);
   assign Out[7] = Op[1] ? (Cnt[3] ? In_4[15] : In_4[7]) : (Cnt[3] ? (Op[0] ? 0 : In_4[15]) : In_4[7]);
   assign Out[6] = Op[1] ? (Cnt[3] ? In_4[14] : In_4[6]) : (Cnt[3] ? (Op[0] ? 0 : In_4[14]) : In_4[6]);
   assign Out[5] = Op[1] ? (Cnt[3] ? In_4[13] : In_4[5]) : (Cnt[3] ? (Op[0] ? 0 : In_4[13]) : In_4[5]);
   assign Out[4] = Op[1] ? (Cnt[3] ? In_4[12] : In_4[4]) : (Cnt[3] ? (Op[0] ? 0 : In_4[12]) : In_4[4]);
   assign Out[3] = Op[1] ? (Cnt[3] ? In_4[11] : In_4[3]) : (Cnt[3] ? (Op[0] ? 0 : In_4[11]) : In_4[3]);
   assign Out[2] = Op[1] ? (Cnt[3] ? In_4[10] : In_4[2]) : (Cnt[3] ? (Op[0] ? 0 : In_4[10]) : In_4[2]);
   assign Out[1] = Op[1] ? (Cnt[3] ? In_4[9] : In_4[1]) : (Cnt[3] ? (Op[0] ? 0 : In_4[9]) : In_4[1]);
   assign Out[0] = Op[1] ? (Cnt[3] ? In_4[8] : In_4[0]) : (Cnt[3] ? (Op[0] ? 0 : In_4[8]) : In_4[0]);

endmodule
