package com.personal.bookstore.common.exception;

public class ErrorCode {
	public enum Code{
		TOKEN_EXPIRED(1001),
	    INVALID_TOKEN(1002),
	    UNAUTHORIZED(1003),
	    INVALID_REF_TOKEN(1004),
	    ACCESS_DENIED(1005);
	    
		private int value;
		
		Code(int value) {
			this.value = value;
		}
		
		public int getValue() {
			return this.value;
		}
		
	}
}
