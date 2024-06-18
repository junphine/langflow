import React, { useRef, useState, useCallback } from "react";
import { faXmark, faPlus, faMinus } from "@fortawesome/free-solid-svg-icons";

import { Character,newCharacter } from "types/Story";
import TableInput from "components/TableInput";
import Modal from "components/Modal";
import ButtonIcon from "components/ButtonIcon";
import "./CharactersModal.css";

interface Props {
  characters: Character[];
  applyChanges: (changes) => void;  
  onClose: () => void;
}

const CharactersModal: React.FC<Props> = ({
  characters = [],
  applyChanges,
  onClose,
}) => {  
  
  const onAddCharacter = useCallback(() => {
    applyChanges({ characters: [...characters, newCharacter()] });
  }, [applyChanges, characters]);

  const onChangeCharacter = useCallback(
    (variable) => {
      applyChanges({
        characters: characters.map((v) => (v.id === variable.id ? variable : v)),        
      });
    },
    [applyChanges, characters]
  );

  const onRemoveCharacter = useCallback(
    (variable) => {
      const goAhead = window.confirm(
        `Are you sure you want to remove "${variable.name}"?`
      );
      if (goAhead)
        applyChanges({
          variables: characters.filter((v) => v.id !== variable.id),         
        });
    },
    [applyChanges, characters]
  );

  const closeCharacters = useCallback(() => {
    if (characters.filter((v) => v.name === "").length > 0) {
      const goAhead = window.confirm(
        "You have unnamed character that will be deleted. Are you sure you want to continue?"
      );
      if (goAhead) {
        applyChanges({
          variables: characters.filter((v) => v.name !== ""),
        });
        
      } else {
        return;
      }
    }
    onClose();  
  }, [applyChanges, characters]);
  return (
    <Modal
      title="Story Characters"
      className="CharactersModal"
      barButton={<ButtonIcon icon={faXmark} onClick={closeCharacters} />}
    >
      <section>
        <TableInput
          headings={["角色名称", "性别", "年龄", "人物介绍","形象照",""]}
          widths={[10, 5, 5, 58, 20, 2]}
          onAddRow={onAddCharacter}
          onAddRowText={"Add character"}
        >
          {characters.map((character, i) => (
            <tr key={i}>
              <td>
                <input
                  id="characterName"
                  value={character.name}
                  placeholder="Enter name"
                  onChange={(e) =>
                    onChangeCharacter({ ...character, name: e.target.value })
                  }
                />
              </td>
              <td>
                <select
                  name="characterGender"
                  id="characterGender"
                  value={character.gender}
                  onChange={(e) =>
                    onChangeCharacter({
                      ...character,
                      gender: e.target.value as string,                      
                    } as Character)
                  }
                >
                  <option value="男性">男性</option>
                  <option value="女性">女性</option>
                  <option value="未知">未知</option>          
                </select>
              </td>
              <td>
                <input
                  id="characterAge"
                  type="number"
                  value={character.age}
                  onChange={(e) =>
                    onChangeCharacter({
                      ...character,
                      age: Number(e.target.value),
                    } as Character)
                  }
                />
              </td>
              <td>
                <input
                  id="characterIntroduction"
                  value={character.introduction}
                  placeholder="Enter personal introduction"
                  onChange={(e) =>
                    onChangeCharacter({ ...character, introduction: e.target.value })
                  }
                />
              </td>
              <td>
                <input
                  id="characterAvatar"
                  value={character.avatar}
                  placeholder="Personal avatar URL"
                  onChange={(e) =>
                    onChangeCharacter({ ...character, avatar: e.target.value })
                  }
                />
              </td>
              <td onClick={() => onRemoveCharacter(character)} id="remove">
                <ButtonIcon icon={faMinus} />
              </td>
            </tr>
          ))}
        </TableInput>
      </section>
    </Modal>
  );
};

export default CharactersModal;
