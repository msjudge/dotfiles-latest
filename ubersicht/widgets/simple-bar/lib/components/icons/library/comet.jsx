import Icon from "../icon.jsx";

export default function Comet(props) {
  return (
    <Icon {...props}>
      <circle cx="16" cy="8" r="3" />
      <path d="M13.5 9.5C11 12 8.5 14 6 15.5C3.5 17 2 17.5 2 17.5C2 17.5 2.5 16 4 13.5C5.5 11 7.5 8.5 10 6C12.5 3.5 15 2 17 2C19 2 19.5 3.5 18 6C17.5 6.8 17 7.5 16.5 8" />
      <path d="M7 17C7.5 16.5 8 16 8.5 15.5M10 14C10.5 13.5 11 13 11.5 12.5" strokeLinecap="round" opacity="0.6" />
    </Icon>
  );
}
