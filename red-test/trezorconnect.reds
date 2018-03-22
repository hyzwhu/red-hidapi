Red/System[]
trezor: context [
	writeTest: func [
		/local
		msg-size   	 	[integer!]
		msg-id     	 	[integer!]
		buf         	[byte-ptr!]
		i           	[integer!]
	][
		buf: as byte-ptr! allocate 64
		i: 12
		msg-id: 11
		buf/1: #"#"
		buf/2: #"#"
		buf/3: as byte! ((msg-id >> 8) and 000000FFh)
		buf/4: as byte! (msg-id and 000000FFh)
		buf/5: as byte! ((msg-size >> 24) and 000000FFh)
		buf/6: as byte! ((msg-size >> 16) and 000000FFh)
		buf/7: as byte! ((msg-size >> 8) and 000000FFh)
		buf/8: as byte! (msg-size and 000000FFh)
		buf/9: as byte! 8
		buf/10: as byte! 1
		buf/11:  as byte! 1 
	    until [
			buf/i: null-byte
			i: i + 1
		    i = 65
		]
	]
]