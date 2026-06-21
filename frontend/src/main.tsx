import { createRoot } from "react-dom/client";
import "bootstrap/dist/css/bootstrap.css";
import { StrictMode } from "react";
import { RouterProvider } from "react-router-dom";
import router from "./app/routes/routes";
import { setInterceptors } from "./shared/api/interceptors";
import { PersistQueryClientProvider } from "@tanstack/react-query-persist-client";
import { QueryClient } from "@tanstack/react-query";
import { persister } from "./shared/hooks/persister";

const queryClient = new QueryClient({
  //staleTime thowi gian data con moi
  //gcTime sau khoang tg nay thi xoa khoi ram
  // ca 2 chi ap dung cho ram cache
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 10,
      gcTime: 1000 * 60 * 60,
      retry: 2, // neu goi api loi tanstack se thu lai bao nhieu lan
      refetchOnWindowFocus: false, //khi quay lại tab trình duyệt, có tự gọi lại API không.
    },
  },
});
setInterceptors();

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{
        persister,
        maxAge: 1000 * 60 * 60 * 24, // sau 1 ngay thi cache persist trong localstorage  bi loai bo persist storage
        dehydrateOptions: {
          shouldDehydrateQuery: (query) => {
            const persistKeys = ["books", "numberOfBooks", "book", "provinces"];
            return persistKeys.includes(query.queryKey[0] as string);
          },
        },
      }}
    >
      <RouterProvider router={router} />
    </PersistQueryClientProvider>
  </StrictMode>,
);
