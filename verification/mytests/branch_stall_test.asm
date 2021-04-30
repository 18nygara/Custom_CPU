lbi r0, 0 		// r0 = 0
bnez r0, .stop_wrng
addi r0, r0, 2		// r0 = 2
beqz r0, .stop_wrng
lbi r1, 4 		// r1 = 4
sll r2, r1, r0 		// r2 = 16
bltz r2, .stop_wrng
bgez r1, .Label1
halt

.label2:
lbi r2, 0 		// r2 = 0
seq r4, r2, r3 		// r4 = 1
bnez r4, .label3
halt

.Label1:
subi r3, r1, 4	 	// r3 = 0
beqz r3, .label2
halt

.label3:
bltz r1, .stop_wrng
bgez r1, .stop

.stop_wrng:
lbi r0, 42
halt

.stop:
lbi r0, 1 		// r0 = 1
halt