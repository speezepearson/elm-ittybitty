module Ittybitty.Fragments exposing
    ( Fragment
    , build
    , getTitle
    , getEncodedBody
    , parse
    , toString
    , parseUrl
    , addToUrl
    )

import Url
import B64Lzma exposing (B64Lzma(..))

type alias RawFragment = { title : String, encodedBody : B64Lzma }

type Fragment = Fragment RawFragment
type ParseError = ParseError

build : String -> B64Lzma -> Fragment
build title encodedBody =
    Fragment {title=title, encodedBody=encodedBody} -- TODO: mangle title like Ittybitty

getTitle : Fragment -> String
getTitle (Fragment {title}) = title

getEncodedBody : Fragment -> B64Lzma
getEncodedBody (Fragment {encodedBody}) = encodedBody

toString : Fragment -> String
toString (Fragment {title, encodedBody}) =
    case encodedBody of
        B64Lzma s -> title ++ "/" ++ s

parse : String -> Result ParseError Fragment
parse s =
    case List.head (String.indexes "/" s) of
        Nothing -> Err ParseError
        Just i -> Ok <| Fragment <|
            { title = String.left i s -- TODO: mangle title like Ittybitty
            , encodedBody = B64Lzma <| String.dropLeft (i+1) s
            }

parseUrl : Url.Url -> Maybe (Result ParseError Fragment)
parseUrl url =
    url.fragment |> Maybe.map parse
addToUrl : Maybe Fragment -> Url.Url -> Url.Url
addToUrl fragment url =
    { url | fragment = fragment |> Maybe.map toString }
