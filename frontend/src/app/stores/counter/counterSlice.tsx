import { createSlice } from "@reduxjs/toolkit";

interface counterSlice {
  value: number;
}

const initialState: counterSlice = { value: 0 };

const counterSlice = createSlice({
  name: "counter",
  initialState,
  reducers: {
    increment: (state) => {
      state.value += 1;
    },
    decrement: (state) => {
      state.value -= 1;
    },
  },
});
// actions ở trong hàm createSlice nó chứa các reducers
export const {increment, decrement} = counterSlice.actions;
export default counterSlice.reducer;
