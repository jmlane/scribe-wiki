module Main exposing (Model, Msg, update, view, subscriptions, init)

import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Navigation


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        apiUrl = "/api/pages" ++ location.pathname

        decodePage : Json.Decode.Decoder Page
        decodePage =
            Json.Decode.map2 Page
                (Json.Decode.field "title" Json.Decode.string)
                (Json.Decode.field "content" Json.Decode.string)

        getPage =
            Http.send PageRequest (Http.get apiUrl decodePage)
    in
        ( Model False "" (Page "First Page" ""), getPage )


type alias Model =
    { editing : Bool
    , currentContent : String
    , currentPage : Page
    }


type alias Page =
    { title : String
    , content : String
    }


type Msg
    = Edit
    | ContentChanged String
    | PageRequest (Result Http.Error Page)
    | Save
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Edit ->
            { model | editing = True } ! [ Cmd.none ]

        ContentChanged newContent ->
            { model | currentContent = newContent } ! [ Cmd.none ]

        PageRequest (Err _) ->
            model ! [ Cmd.none ]

        PageRequest (Ok page) ->
            { model | currentPage = page } ! [Cmd.none ]

        Save ->
            let
                currentPage = model.currentPage
                newPage = { currentPage | content = model.currentContent }
            in
                { model | editing = False, currentPage = newPage } ! [ Cmd.none ]
        
        UrlChange location ->
            model ! [ Cmd.none ]


view : Model -> Html Msg
view model =
    section []
        [ h1 [] [ text model.currentPage.title ]
        , viewContent model.editing model.currentPage.content
        , br [] []
        , viewEditButtons model.editing
        ]


viewContent : Bool -> String -> Html Msg
viewContent edit content =
    let
        onChange : (String -> Msg) -> Html.Attribute Msg
        onChange event =
            Html.Events.on "change" <| Json.Decode.map event Html.Events.targetValue
    in
        if edit then
            textarea [ id "content", onChange ContentChanged ] [ text content ]
        else
            p [] [ text content ]


viewEditButtons : Bool -> Html Msg
viewEditButtons edit =
    let
        button =
            if edit then
                Html.button [ onClick Save ] [ text "Save" ]
            else
                Html.button [ onClick Edit ] [ text "Edit" ]
    in
        div [] [ button ]
