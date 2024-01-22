import Style from "./button.module.css";

const Button =({btnName, handleClick, classStyles})=>(
    <button className={StylePropertyMap.button} type="button" onClick={handleClick} >
    {btnName}
    </button>
);
export default Button;