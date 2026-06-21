let username: string | null = null;

export const setUsername = (us: string) => {
  username = us;
};

export const getUsername = () => {return username};
