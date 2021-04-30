// test for forwarding instructions for demo2

lbi r0, 2			// r0 = 2
lbi r1, 3			// r1 = 3
sub r2, r1, r0 			// r2 = -1
add r3, r2, r1 			// r3 = 2
bltz r2, .label1 		// take
halt 				// doesn't execute

.label2:
lbi r0, 100 			// r0 = 100
halt 				// finish
st r0, r4, 1 			// doesn't execute

.label1:
andn r4, r3, r2 		// r4 = 0
addi r0, r4, 5 			// r0 = 5
rol r1, r0, r3 			// r1 = 20
sle r2, r0, r1 			// r2 = 1
bgez r2, .label2 		// taken
lbi r7, 99 			// doesn't execute
halt