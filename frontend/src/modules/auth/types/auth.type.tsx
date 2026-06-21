interface User{
    username: string |null
}

export default interface AuthType{
    user: User | null,
    accessToken: string | null,
    setAuth: (data: Partial<AuthType>) => void,
    clearAuth: () => void
    //Partial<AuthState> cho phen truyen 1 phan, phan con laij dc phep bo qua
    
}