import "../styles/globals.css";

//internal import
import { VotingProvider } from "../context/voter";
import Navbar from "../components/NavBar/NavBar";
const MyApp = ({Component,pageProps})=> (
    <VotingProvider>
    <div>
        {/* <NavBar /> */}
        <div>
        <Component{...pageProps}/>;
        </div>
    </div>
    </VotingProvider>
);
export default MyApp;